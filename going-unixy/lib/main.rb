require_relative "./component/nginx"
require_relative "./component/podman"

Component::Podman.install
Component::Nginx.install
