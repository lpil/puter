require_relative "./shell"

module Apt
  def self.install(package)
    Shell.exec_print("apt-get -qq install --yes #{package}")
  end

  def self.installed?(package)
    Shell.success?("dpkg -s #{package}")
  end

  def self.assert_installed(package)
    raise "apt package #{package} is not installed" unless installed?(package)
  end
end
