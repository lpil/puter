require_relative "../container"
require_relative "../component"
require_relative "../systemd"
require_relative "../shell"
require_relative "../http_client"

#
#
# TODO: https://podman.io/blogs/2018/09/13/systemd.html
#
#

class Component::Thelounge < Component
  PORT = 8000
  IMAGE_TAG = "4.1.0-alpine"
  DATA_DIR = "/var/opt/thelounge"
  NGINX_CONFIG = "/etc/nginx/sites-enabled/thelounge"

  def install(host:)
    log "Ensuring nginx is running"
    Systemd.assert_running("nginx")

    log "Ensuring podman is installed"
    Apt.assert_installed("podman")

    if Container.exists?("thelounge")
      log "Thelounge container already exists"
    else
      log "Creating data directory #{DATA_DIR}"
      Shell.exec_print("mkdir -p #{DATA_DIR}")

      log "Creating container"
      Shell.exec_print(create_container_command)
    end

    log "Writing nginx config #{NGINX_CONFIG}"
    File.write(NGINX_CONFIG, nginx_config(host))

    log "Reloading nginx"
    Shell.exec_print("systemctl reload nginx")

    log "Ensuring #{host} is being served"
    HttpClient.assert_200("https://" + host)
  end

  private

  def create_container_command
    "
    podman run --detach \
      --name thelounge \
      --publish #{PORT}:9000 \
      --volume #{DATA_DIR}:/var/opt/thelounge \
      --restart always \
      thelounge/thelounge:#{IMAGE_TAG}
    "
  end

  def nginx_config(host)
    "
server {
  server_name #{host};

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

  # HTTPS using certbot provisioned cert
  listen [::]:443 ssl ipv6only=on;
  listen 443 ssl;
  ssl_certificate /etc/letsencrypt/live/#{host}/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/#{host}/privkey.pem;
  include /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

server {
  if ($host = #{host}) {
    return 301 https://$host$request_uri;
  }

  listen 80;
  listen [::]:80;

  server_name #{host};
  return 404;
}
"
  end
end
