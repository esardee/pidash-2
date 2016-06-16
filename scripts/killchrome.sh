#!/bin/sh

# Find the PID for iceweasel and kill it
pid_chrome="$(pgrep -f chromium)"
kill $pid_chrome
