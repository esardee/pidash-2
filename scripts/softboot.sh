#!/bin/sh

# This file is not required anymore.

# Find the PID for iceweasel and kill it
pid_iceweasel="$(pgrep -f iceweasel)"
kill $pid_iceweasel

sleep 1s
