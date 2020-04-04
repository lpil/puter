#!/usr/bin/env sh
set -eu

# Taken from https://podman.io/getting-started/installation.html

. /etc/os-release

echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/Release.key | apt-key add -

apt-get update -qq
apt-get -qq --yes install podman
