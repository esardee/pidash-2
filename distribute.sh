#!/bin/sh

# Use this file to move the Git repo files to the correct areas and change their permissions so you can use them!
# Should be run as su, otherwise the chmod will fail.

cp * -R /var/www/html/
cd /var/www/html
chmod 777 * -R

# Test commit 1234
