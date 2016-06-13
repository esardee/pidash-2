#!/bin/sh

# if ! pgrep "iceweasel" > /dev/null
# then
    # kill all existing iceweasel instances anyway
    pid_iceweasel="$(pgrep -f iceweasel)"
    kill $pid_iceweasel
    sleep 1s

    # Restart the browser
    unclutter &
    matchbox-window-manager &
    iceweasel https://www.g123123oo222gle.com --display=:1 &
    sleep 10s
# fi
