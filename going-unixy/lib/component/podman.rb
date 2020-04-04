require_relative "../component"
require_relative "../apt"

class Component::Podman < Component
  def install
    if Apt.installed?("podman")
      log "Already installed"
      return
    end

    log "Installing podman"
    Shell.exec_print_script("install_podman.sh")

    log "Ensuring package is installed"
    Apt.assert_installed("podman")
  end
end
