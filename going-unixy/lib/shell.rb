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
    raise ShellError, "command `#{command}` failed to run\n\n#{output}" unless $?.success?
    output.chomp
  end

  # Exec a shell command, returning whether it exited with the 0 success code
  def self.success?(command)
    `#{command} 2> /dev/null`
    $?.success?
  end

  # Exec a script, streaming the output the console
  def self.exec_print_script(command)
    exec_print(__dir__ + "/../scripts/" + command)
  end
end
