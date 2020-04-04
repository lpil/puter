require_relative "../component"
require_relative "../apt"
require_relative "../systemd"
require_relative "../http_client"

class Component::Nginx < Component
  def install
    if Apt.installed?("nginx")
      log "nginx already installed"
      return
    end

    log "Installing nginx"
    Apt.install("nginx")

    log "Ensuring systemd unit nginx is running"
    Systemd.assert_running("nginx")

    log "Ensuring http://localhost is being served"
    HttpClient.assert_200("http://localhost")
  end
end
