#!/bin/bash

# This script is used for configuring a newly created ubuntu server box. 
# The objective is to create a bare bones development box that can be used for development using virtualbox.


$current_user=$(whoami)
sudo su
apt-get update
# Install misc stuff
apt-get install xorg --no-install-recommends
apt-get install vim vim-gtk most --no-install-recommends 

# No password for sudo
groupadd -r admin
usermod -a -G admin $current_user 
sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=admin' /etc/sudoers
sed -i -e 's/%admin ALL=(ALL) ALL/%admin ALL=NOPASSWD:ALL/g' /etc/sudoers

#Set root prompt to Red
echo 'PS1="\[\e[31m\]\h:\w#\[\e[m\] "' >> /root/.bashrc

# Colored Man pages
echo 'export MANPAGER="/usr/bin/most -s"' >> /root/.profile
echo 'export MANPAGER="/usr/bin/most -s"' >> /home/$current_user/.profile

# Install virtualbox guest addtions
installVirtualBoxExt(){
	apt-get install gcc make --no-install-recommends
	echo -n "Enter virtual box version number: (Eg. 4.1.16) "
	read vbox_version
	cd /tmp
	wget http://download.virtualbox.org/virtualbox/$vbox_version/VBoxGuestAdditions_$vbox_version.iso
	mount -o loop VBoxGuestAdditions_$vbox_version.iso /mnt
	sh /mnt/VBoxLinuxAdditions
	umount /mnt
	rm VBoxGuestAdditions_$vbox_version.iso
}

echo -n "Install Virtual box extension ? (Y/N)"
read choice
case $choice in
	[Yy]*) installVirtualBoxExt
		exit;;
	*) exit;;
esac

#Install window manager
apt-get install xmonad libghc-xmonad-dev libghc-xmonad-contrib-dev --no-install-recommends
