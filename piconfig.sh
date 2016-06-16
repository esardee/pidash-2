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

# The first thing that has to be done is changing the Raspberry Pi config.
# Run the following:
#
#   sudo raspi-config
#
# then make the following changes
#   - Update Raspi Config Tool (Advanced Settings)
#   - Disable Overscan (Advanced Settings)
#   - Memory Split (Advanced Settings) - Give the GPU 128MB

# ============================================================
#     Connect to the WiFi (Optional)
# ============================================================

  # Get the Wireless SSID
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
    sudo echo 'ssid="' $ssid '"' >> $wpaconf
    sudo echo 'psk="' $psk '"' >> $wpaconf
    sudo echo '}' >> $wpaconf

    # Replace manual with DHCP in /etc/network/interfaces
    sudo sed -i "s/iface wlan0 inet manual/iface wlan0 inet dhcp" /etc/network/interfaces

  fi

# ============================================================
#     Install All The Things!
# ============================================================

  # Upgrade packages
  sudo apt-get update -y
  sudo apt-get upgrade -y

  # Install packages
  sudo apt-get install iceweasel gnash gnash-common browser-plugin-gnash x11-xserver-utils matchbox xautomation unclutter -y

  # Install Apache
  sudo apt-get install apache2 -y

  # Install PHP
  sudo apt-get install php5 libapache2-mod-php5 -y

  # Install VNC (Good for troubleshooting)
  sudo apt-get install tightvncserver -y

# ============================================================
#     Create Some Files (we'll use them later)
# ============================================================

  # fullscreen.sh - this launches the browser.
  fspath='/home/pi/fullscreen.sh'
  sudo echo 'unclutter &' >> $fspath
  sudo echo 'matchbox-window-manager &' >> $fspath
  sudo echo 'iceweasel http://pisarada.ddns.net --display=:0 &' >> $fspath
  sudo echo 'sleep 10s' >> $fspath

  # resize.sh - this maximises the browser
  rspath='/home/pi/resize.sh'
  sudo echo 'xte "key F11" -x:0' >> $rspath

# ============================================================
#     Modify the Startup
# ============================================================

  # Modify the autostart file.
  autostart='~/.config/lxsession/LXDE-pi/autostart'
  sudo echo '@xset s off' >> $autostart
  sudo echo '@xset -dpms' >> $autostart
  sudo echo '@xset s noblank' >> $autostart
  sudo echo '@/home/pi/fullscreen.sh' >> $autostart
  sudo echo '@/home/pi/resize.sh' >> $autostart

  # Edit the StartX scripts
  sudo sed -i "s/exit 0/su -l pi -c startx" /etc/rc.local
  sudo echo "exit 0" >> /etc/rc.local

# ============================================================
#     Configure the Git Repo
# ============================================================

# Remove the default html directory
sudo mv /var/www/html /var/www/html.old

# Clone the Git repo to the html directory
sudo git clone https://github.com/esardee/pidash-2 /var/www/html

# Change the file permissions in the html directory
sudo chmod 777 /var/www/html -R


# ============================================================
#     Add a CRON job
# ============================================================

  # Write out current tab
  crontab -l > mycron

  # Echo new cron into cron file
  # Run a 'git pull' every hour for any code changes
  echo "0 * * * * cd /var/www/html && sudo git pull" >> mycron

  # Install new cron file
  crontab mycron
  rm mycron

# ============================================================
#     Modify Permissions
# ============================================================

  # This allows the Pi to be rebooted from the website.
  sudo echo "pi ALL = NOPASSWD: /sbin/reboot" >> /etc/sudoers

  # This makes 'Pi' the user that runs Apache.
  sudo sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=pi/" /etc/apache2/envvars
  sudo sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=pi/" /etc/apache2/envvars

  # This makes the scripts executable
  sudo chmod 777 /home/pi/fullscreen.sh /home/pi/resize.sh
  sudo chmod 777 /var/www/html -R
