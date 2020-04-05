require_relative "../component"
require_relative "../shell"

# Check like so:
#
#     ufw status verbose
#
class Component::Firewall < Component
  def install
    log "Configuring firewall"
    Shell.exec("ufw default deny incoming")
    Shell.exec("ufw default allow outgoing")
    Shell.exec("ufw allow ssh")
    Shell.exec("ufw allow http")
    Shell.exec("ufw allow https")
    Shell.exec("ufw --force enable")
  end
end
