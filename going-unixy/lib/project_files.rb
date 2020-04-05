module ProjectFiles
  def self.write(file, to:)
    file = "#{__dir__}/../files/#{file}"
    FileUtils.mkdir_p(File.dirname(to))
    FileUtils.cp(file, to)
  end
end
