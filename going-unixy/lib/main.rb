require_relative "./component/nginx"
require_relative "./component/podman"
require_relative "./component/thelounge"

Component::Podman.install
Component::Nginx.install
Component::Thelounge.new.install(irc_host: "http://irc-2.lpil.uk")
