require_relative "./component/duplicacy"
require_relative "./component/nginx"
require_relative "./component/podman"
require_relative "./component/thelounge"
require_relative "./component/certbot"

hosts = [
  irc_host = "irc-3.lpil.uk",
]

Component::Duplicacy.new.install
Component::Nginx.new.install
Component::Certbot.new.install(domains: hosts)
Component::Podman.new.install
Component::Thelounge.new.install(host: irc_host)
