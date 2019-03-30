#!/bin/sh
### BEGIN INIT INFO
# Provides:          {{ name }}
# Required-Start:    $local_fs $network $named $time $syslog
# Required-Stop:     $local_fs $network $named $time $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Description:       A rkt service
### END INIT INFO

start() {
  rkt --insecure-options=image run "{{ image }}" --name="{{ name }}" --net=host &
}

stop() {
  rkt stop "{{ name }}"
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  uninstall)
    echo Uninstall command not implemented
    exit 1
    ;;
  retart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|uninstall}"
esac
