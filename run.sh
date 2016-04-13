#!/usr/bin/env bash

set -e # Exit if any fail
set -u # Error on unset vars
set -o pipefail

export ANSIBLE_NOCOWS=1

command -v ansible-playbook >/dev/null 2>&1 || {
  sudo apt-get install ansible
}

ansible-playbook laptop.yml -i hosts.ini --ask-sudo-pass --diff
