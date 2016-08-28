#!/bin/sh
# The following needs to be done AFTER Raspbian Jessie has been installed.
# This can be done by doing the following:

# ============================================================
### Unmount the SD Card
### where <num> is the disk number of the SD card.
# diskutil unmountDisk /dev/disk<num>

### Write the image file onto the SD card
### where '<image>.img' is the path to the Raspbian Jessie image file and <num> is the disk number of the SD card.
### THIS TAKES A LONG TIME
# sudo dd bs=1m if=<image>.img of=/dev/disk<num>

### Unmount the SD Card again.
### where <num> is the disk number of the SD card.
# diskutil unmountDisk /dev/disk<num>

# ============================================================

# From here, connect to the Raspbery Pi using SSH.
# ssh pi@<ip address>
#
# 1. Run the following: curl https://raw.githubusercontent.com/esardee/pidash-2/master/piconfig2.sh > /home/pi/install.sh
# 2. Then: sudo sh /home/pi/install.sh

# ============================================================
#     Configure the internetz
# ============================================================

    # Get the Wireless SSID
    echo
    echo -n "Enter the Wireless SSID: "
    read ssid

    # Don't ask for the PSK if no SSID was entered.
    if [ -z $ssid ]
    then
        echo "SSID was not entered, skipping."
    else
        echo -n "Enter the Wireless Password: "
        read psk

        # Update the wpa_supplicant.conf file with the above information
        wpaconf='/etc/wpa_supplicant/wpa_supplicant.conf'
        sudo echo 'network={' >> $wpaconf
        sudo echo 'ssid="'$ssid'"' >> $wpaconf
        sudo echo 'psk="'$psk'"' >> $wpaconf
        sudo echo '}' >> $wpaconf

        # Replace manual with DHCP in /etc/network/interfaces
        sudo sed -i "s/iface wlan0 inet manual/iface wlan0 inet dhcp/" /etc/network/interfaces

    fi

# ============================================================
#     Install the things
# ============================================================

    # Update the apt-get packages
    sudo apt-get update
    sudo apt-get upgrade -y

    # Install stuff we need
    sudo apt-get install x11-xserver-utils unclutter -y

    # Install Chromium (cannot install using apt-get)
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser-l10n_48.0.2564.82-0ubuntu0.15.04.1.1193_all.deb
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo dpkg -i chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo dpkg -i chromium-browser-l10n_48.0.2564.82-0ubuntu0.15.04.1.1193_all.deb chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo apt-get chromium-browser install -y

    # Install Apache
    sudo apt-get install apache2 -y

    sleep 5s

    # Install PHP
    sudo apt-get install php5 libapache2-mod-php5 -y

    # Install VNC (Good for troubleshooting)
    sudo apt-get install tightvncserver -y

# ============================================================
#     Create Some Files (we'll use them later)
# ============================================================

    # dashboard.sh - this launches the browser. The URL here is a placeholder to load something to start.
    dbpath='/home/pi/dashboard.sh'
    sudo echo '# start / restart the browser' >> $dbpath
    sudo echo 'chromium-browser --display=:0 --noerrdialogs --no-first-run --kiosk http://www.google.com --incognito' >> $dbpath

# ============================================================
#     Modify the Startup
# ============================================================

    # Modify the autostart file.
    autostart='/home/pi/.config/lxsession/LXDE-pi/autostart'

    # Comment out the screensaver
    sudo sed 's/@xscreensaver -no-splash/#@xscreensaver -no-splash' $autostart
    sudo echo '@xset s off' >> $autostart
    sudo echo '@xset -dpms' >> $autostart
    sudo echo '@xset s noblank' >> $autostart
    sudo echo '@sh /home/pi/dashboard.sh' >> $autostart

    sudo chown pi:pi $autostart

# ============================================================
#     Configure the Git Repo
# ============================================================

    # Remove the default html directory
    sudo mv /var/www/html /var/www/html.old

    # Clone the Git repo to the html directory
    sudo git clone https://github.com/esardee/pidash-2 /var/www/html

# ============================================================
#     Modify Permissions
# ============================================================

    # This allows the Pi to be rebooted from the website.
    sudo echo "pi ALL = NOPASSWD: /sbin/reboot" >> /etc/sudoers

    # This makes 'Pi' the user that runs Apache.
    sudo sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=pi/" /etc/apache2/envvars
    sudo sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=pi/" /etc/apache2/envvars

    # This makes the scripts executable
    sudo chmod 777 /home/pi/dashboard.sh
    sudo chmod 777 /var/www/html -R
    sudo chown pi:pi /home/pi/dashboard.sh
    sudo chown -R pi:pi /var/www/html

    echo
    echo 'You need to run the following as the Pi user:'
    echo 'export DISPLAY=:0'
    echo 'xhost +'
    echo
    echo 'crontab -l > mycron'
    echo 'echo "0 * * * * cd /var/www/html && git reset --hard && git pull" >> mycron' 
    echo 'crontab mycron'
    echo 'rm mycron'
    echo
