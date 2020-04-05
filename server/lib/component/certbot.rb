require_relative "../persistence"
require_relative "../component"
require_relative "../systemd"
require_relative "../shell"
require_relative "../systemd"

class Component::Certbot < Component
  def install(domains:)
    log "Ensuring nginx is running"
    Systemd.assert_running("nginx")

    if Apt.installed?("python-certbot-nginx")
      log "Certbot already installed"
    else
      log "Creating symlink for data directory backup"
      Persistence.create_backed_up_directory("letsencrypt", path: "/etc/letsencrypt")

      log "Adding certbot apt repository"
      Apt.add_repository("ppa:certbot/certbot")

      log "Installing certbot and nginx plugin"
      Apt.install("python-certbot-nginx")
    end

    log "Running certbot"
    Shell.exec_print(certbot_command(domains))
  end

  private

  def certbot_command(domains)
    "certbot certonly -q -n --nginx #{domains.map { |h| "-d #{h}" }.join(" ")}"
  end
end
