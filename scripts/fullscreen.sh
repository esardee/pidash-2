#!/bin/sh

if ! pgrep "iceweasel" > /dev/null
then
    unclutter &
    matchbox-window-manager &
    iceweasel https://www.g123123oo222gle.com --display=:1 &
    sleep 10s
fi
