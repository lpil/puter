# https://wiki.archlinux.org/index.php/Systemd/Timers
#
# the calendar value can be tested like so:
#
#     systemd-analyze calendar daily
#     systemd-analyze calendar weekly
#     systemd-analyze calendar 'Mon,Tue *-*-01..04 12:00:00'
#
# List installed timers like so:
#
#     systemctl list-timers
#
# View status of a timer like so:
#
#     systemctl status myunit.timer
#
class Systemd::CalendarTimer
  def initialize(name:, command:, calendar:, workdir: nil, env_vars: {})
    @name = name
    @command = command
    @calendar = calendar
    @env_vars = env_vars
    @workdir = workdir
  end

  def install
    FileUtils.mkdir_p("/usr/lib/systemd/system")
    File.write("/usr/lib/systemd/system/#{@name}.service", "
[Unit]
Description=#{@name}

[Service]
ExecStart=#{@command}
#{env_vars_statement}
#{workdir_statement}
")

    File.write("/usr/lib/systemd/system/#{@name}.timer", "
[Unit]
Description=#{@name}

[Timer]
OnCalendar=#{@calendar}
Persistent=true

[Install]
WantedBy=multi-user.target
")
    Shell.exec("systemctl daemon-reload")
    Shell.exec("systemctl start #{@name}.timer")
  end

  private

  def env_vars_statement
    if @env_vars.any?
      "Environment=#{@env_vars.map { |k, v| "\"#{k}=#{v}\"" }.join(" ")}"
    else
      ""
    end
  end

  def workdir_statement
    if @workdir
      "WorkingDirectory=#{@workdir}"
    else
      ""
    end
  end
end
