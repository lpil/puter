require_relative "./shell"

module Apt
  def self.install(package)
    Shell.exec_print("apt-get install -qq --yes #{package}")
  end
end
