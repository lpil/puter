
require_relative "../component"
require_relative "../systemd"
require_relative "../shell"
require_relative "../http_client"

class Component::Thelounge < Component
  PORT = 8000
  IMAGE_TAG = "4.1.0-alpine"
  DATA_DIR = "/var/opt/thelounge"
  NGINX_CONFIG = "/etc/nginx/sites-enabled/thelounge"

  def install(irc_host:)
    if File.exist?(NGINX_CONFIG)
      log "Already installed"
      return
    end

    log "Creating data directory #{DATA_DIR}"
    Shell.exec_print("mkdir -p #{DATA_DIR}")

    log "Running container"
    Shell.exec_print(run_container_command)

    log "Writing nginx config #{NGINX_CONFIG}"
    File.write(NGINX_CONFIG, nginx_config)

    log "Reloading nginx"
    Shell.exec_print("systemctl reload nginx")

    log "Ensuring #{irc_host} is being served"
    HttpClient.assert_200(irc_host)
  end

  private

  def run_container_command
    "
    podman run --detach \
      --name thelounge \
      --publish #{PORT}:9000 \
      --volume #{DATA_DIR}:/var/opt/thelounge \
      --restart always \
      thelounge/thelounge:#{IMAGE_TAG}
    "
  end

  def nginx_config
    "
server {
  listen 80;
  listen [::]:80;
  # listen 443;
  # listen [::]:443;

  server_name irc-2.lpil.uk;

  location / {
    proxy_pass http://127.0.0.1:#{PORT}/;
    proxy_http_version 1.1;
    proxy_set_header Connection \"upgrade\";
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header X-Forwarded-Proto $scheme;

    # by default nginx times out connections in one minute
    proxy_read_timeout 1d;
  }
}\n"
  end
end
