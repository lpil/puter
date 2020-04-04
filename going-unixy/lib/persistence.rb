module Persistence
  REPO = "/root/data".freeze

  def self.create_backed_up_directory(name, path:)
    target = "#{REPO}/#{name}"

    # Symlink already created
    return if File.exists?(path) && File.symlink?(path) && File.readlink(path) == target

    File.symlink(target, path)
  end
end
