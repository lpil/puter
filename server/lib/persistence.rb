require 'fileutils'

module Persistence
  REPO = "/root/data".freeze

  def self.create_backed_up_directory(name, path:)
    target = "#{REPO}/#{name}"
    FileUtils.mkdir_p(target)
    create_backed_up_file(name, path: path)
  end

  def self.create_backed_up_file(name, path:)
    target = "#{REPO}/#{name}"
    FileUtils.mkdir_p(File.dirname(path))

    # Symlink already created
    return if File.exists?(path) && File.symlink?(path) && File.readlink(path) == target

    File.symlink(target, path)
  end
end
