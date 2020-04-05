require 'fileutils'
require_relative "../../secrets"
require_relative "../persistence"
require_relative "../component"
require_relative "../apt"
require_relative "../systemd"
require_relative "../systemd/calendar_timer"
require_relative "../http_client"

class Component::Duplicacy < Component
  VERSION = "2.4.1"
  BINARY_PATH = "/usr/local/bin/duplicacy"
  REMOTE_PATH = "https://github.com/gilbertchen/duplicacy/releases/download/v#{VERSION}/duplicacy_linux_x64_#{VERSION}"

  def install
    if File.exists?(BINARY_PATH)
      log "Duplicacy already installed"
    else
      log "Downloading binary"
      Shell.exec_print("wget -q -O #{BINARY_PATH} #{REMOTE_PATH}")

      log "Marking binary executable"
      Shell.exec_print("chmod 755 #{BINARY_PATH}")
    end

    if File.exists?(Persistence::REPO + "/.duplicacy")
      log "Repo already created"
    else
      log "Creating repo"
      FileUtils.mkdir_p(Persistence::REPO)
      Shell.exec_print(in_repo("duplicacy init server-data b2://lpil-server-data"))

      log "Looking up latest backup revision"
      revision = get_latest_revision_number

      log "Restoring latest backup (#{revision})"
      Shell.exec_print(in_repo("duplicacy restore -r #{revision}"))
    end

    log "Installing systemd timer for backups"
    Systemd::CalendarTimer.new(
      name: "duplicacy_backup",
      command: "#{BINARY_PATH} backup -stats -threads 4",
      calendar: "daily",
      workdir: Persistence::REPO,
      env_vars: {
        DUPLICACY_B2_ID: Secrets::BACKBLAZE_KEY_ID,
        DUPLICACY_B2_KEY: Secrets::BACKBLAZE_APPLICATION_KEY,
      }
    ).install
  end

  private

  def get_latest_revision_number
    last_revision = Shell.exec(in_repo("duplicacy list | tail -1"))
    /^Snapshot server-data revision ([0-9]+)/
      .match(last_revision)
      .captures
      .first || fail("Unable to get revision number from `#{last_revision}`")
  end

  def in_repo(command)
    "cd #{Persistence::REPO} && \
    DUPLICACY_B2_ID=#{Secrets::BACKBLAZE_KEY_ID} \
    DUPLICACY_B2_KEY=#{Secrets::BACKBLAZE_APPLICATION_KEY} \
    #{command}"
  end
end
