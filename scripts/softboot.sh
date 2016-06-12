#!/bin/sh

# Find the PID for iceweasel and kill it
pid_iceweasel="$(pgrep -f iceweasel)"
kill $pid_iceweasel

# Reload the new file...
# [this might not work]
# /bin/sh /home/pi/fullscreen.sh
