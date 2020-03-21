module Shell
  class ShellError < StandardError
  end

  # Exec a shell command, streaming the output the console
  def self.exec_print(command)
    system(command) || raise(ShellError, "command `#{command}` failed to run")
  end

  # Exec a shell command, returning the output as a string
  def self.exec(command)
    output = `#{command}`
    raise ShellError, "command `#{command}` failed to run" unless $?.success?
    output.chomp
  end
end
