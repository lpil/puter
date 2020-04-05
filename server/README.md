# Going UNIXy

1. scp a dir of scripts to the host
2. exec each script over ssh
3. script checks if work is to be done and exits early if the work is already
   done (by a previous run)
4. script (if still running) installs the thing or whatever it's meant to do

tada.

Do we want shell scripts or Ruby scripts?

## Things to install

- nginx
  - install via apt
  - ensure is running
- certbot
  - install via apt
  - ensure cronjob is set up
- podman for running container images
- github.com/thelounge/thelounge irc client
  - installed via container image
  - data in /var/lib/thelounge
  - config in /etc/thelounge
  - systemd unit created and started
  - configure nginx with irc.lpil.uk site
  - rerun certbot to get irc.lpil.uk cert
    - check wtf nginx actually did with that
  - ensure is running via nginx (will require hosts file entry)
  - maybe some code to pull the image and restart if we want a different
    version than is running.
- backups to wasbi.com using github.com/gilbertchen/duplicacy

## Test with Vagrant

_if_ it seems useful.

- Most likely certbot won't work.
- Will need to add entries to the host machines' /etc/hosts + do port
  forwarding for nginx to route requests correctly.
- Will need to add test domains to the nginx config as well as the prod ones.
