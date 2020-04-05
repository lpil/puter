module ProjectFiles
  def self.write(file, to:)
    file = "#{__dir__}/../files/#{file}"
    FileUtils.cp(file, to)
  end
end
