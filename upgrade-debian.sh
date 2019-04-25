sudo cp /etc/apt/sources.list /etc/apt/sources.list.wheezy
#sudo sed -i 's/wheezy/jessie/g' /etc/apt/sources.list
wget https://raw.githubusercontent.com/arkceajin/shell-script/master/sources.list
sudo cp -f sources.list /etc/apt/sources.list

sudo touch /etc/apt/sources.list.d/crosstools.list
sudo touch /etc/apt/sources.list.d/atmark-techno.list
sudo chmod a+w /etc/apt/sources.list.d/crosstools.list
sudo chmod a+w /etc/apt/sources.list.d/atmark-techno.list
sudo echo "deb http://emdebian.org/tools/debian/ jessie main" > /etc/apt/sources.list.d/crosstools.list
sudo echo "deb http://download.atmark-techno.com/debian/ jessie main contrib non-free" > /etc/apt/sources.list.d/atmark-techno.list

curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add -
sudo dpkg --add-architecture armel
sudo apt-get update
sudo apt-get upgrade
sudo apt-get dist-upgrade
sudo apt-get install virtualbox-guest-dkms virtualbox-guest-x11 linux-headers-$(uname -r)
sudo apt-get install gnome-terminal
sudo apt-get install nautilus
sudo apt-get install gdm3
sudo reboot
