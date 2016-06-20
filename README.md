# Raspberry Pi Dashboard Updater
This is to be installed on an apache server running on a Raspberry Pi.

# Installation
To start this you need to install Raspbian Jessie. Do this by doing the following:

1. Insert the SD Card into your Mac using a card reader.
2. Unmount the disk:

  `diskutil unmountDisk /dev/disk<num>`
  
  *where <num> is the disk number of the SD card.*

3. Write the image file onto the SD card (30 minutes)

  `sudo dd bs=1m if=<image>.img of=/dev/disk<num>`

  *where '<image>.img' is the path to the Raspbian Jessie image file and <num> is the disk number of the SD card.*

4. Unmount the SD card and remove then reinsert into Pi.

	`diskutil unmountDisk /dev/disk<num>`
	
	*where <num> is the disk number of the SD card.*

5. SSH from the terminal into the Pi.

  `ssh pi@<ip address>`

6. Run the following:  

  `curl https://raw.githubusercontent.com/esardee/pidash-2/master/piconfig2.sh > /home/pi/install.sh`

7. Then run the following. You will be asked to enter some WiFi information at the start.

  `sudo sh /home/pi/install.sh`

8. Once that is complete, follow the instructions on screen and run the following:

  `export DISPLAY=:0`

  `xhost +`

9. Reboot your Pi.

  `sudo reboot`

10. Once restarted, you should have a browser loading on the screen. You can browse to the Pi's internal IP address and update the URL from there.
