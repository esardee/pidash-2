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


# ============================================================
#     Configure the internetz
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
#     Install the things
# ============================================================

    # Update the apt-get packages
    sudo apt-get update
    sudo apt-get upgrade -y

    # Install stuff we need
    sudo apt-get install chromium x11-xserver-utils unclutter

    # Install Chromium (cannot install using apt-get)
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser-l10n_48.0.2564.82-0ubuntu0.15.04.1.1193_all.deb
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    wget http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo dpkg -i chromium-codecs-ffmpeg-extra_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo dpkg -i chromium-browser-l10n_48.0.2564.82-0ubuntu0.15.04.1.1193_all.deb chromium-browser_48.0.2564.82-0ubuntu0.15.04.1.1193_armhf.deb
    sudo apt-get chromium-browser install -y

    # Set the display for Chromium to load on. 1 is for testing, 0 is for prod.
    export DISPLAY=:1

    # If the above doesn't work, run one of the following blocks then 'sudo apt-get install chromium-browser -y' again.

    # BLOCK 1 #
    # wget -qO - http://bintray.com/user/downloadSubjectPublicKey?username=bintray | sudo apt-key add -
    # echo "deb http://dl.bintray.com/kusti8/chromium-rpi jessie main" | sudo tee -a /etc/apt/sources.list

    # BLOCK 2 #
    # wget http://ftp.us.debian.org/debian/pool/main/libg/libgcrypt11/libgcrypt11_1.5.0-5+deb7u3_armhf.deb
    # wget http://launchpadlibrarian.net/218525709/chromium-browser_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
    # wget http://launchpadlibrarian.net/218525711/chromium-codecs-ffmpeg-extra_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
    # sudo dpkg -i libgcrypt11_1.5.0-5+deb7u3_armhf.deb
    # sudo dpkg -i chromium-codecs-ffmpeg-extra_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb
    # sudo dpkg -i chromium-browser_45.0.2454.85-0ubuntu0.14.04.1.1097_armhf.deb

    # Install kweb
    wget http://steinerdatenbank.de/software/kweb-1.7.1.tar.gz
    tar -xzf kweb-1.7.1.tar.gz
    cd kweb-1.7.1
    ./debinstall

# ============================================================
#     Modify the Startup
# ============================================================

  # Modify the autostart file.
  autostart='~/.config/lxsession/LXDE-pi/autostart'

  # Comment out the screensaver
  sudo sed 's/@xscreensaver -no-splash/#@xscreensaver -no-splash' $autostart
  sudo echo '@xset s off' >> $autostart
  sudo echo '@xset -dpms' >> $autostart
  sudo echo '@xset s noblank' >> $autostart
  sudo echo '@sed -i ''''s/'"exited_cleanly"': false/'"exited_cleanly"': true/'' ~/.config/chromium/Default/Preferences' >> $autostart
  sudo echo '@/home/pi/dashboard.sh' >> $autostart

  # The following needs to go into dashboard.sh:
  # chromium-browser --noerrdialogs --kiosk http://www.page-to.display --incognito
