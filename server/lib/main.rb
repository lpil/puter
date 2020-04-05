require_relative "./component/certbot"
require_relative "./component/duplicacy"
require_relative "./component/firewall"
require_relative "./component/nginx"
require_relative "./component/podman"
require_relative "./component/thelounge"

hosts = [
  irc_host = "irc.lpil.uk",
]

Component::Firewall.new.install
Component::Duplicacy.new.install
Component::Nginx.new.install
Component::Certbot.new.install(domains: hosts)
Component::Podman.new.install
Component::Thelounge.new.install(host: irc_host)
