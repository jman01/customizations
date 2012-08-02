#!/bin/bash

# This script is used for configuring a newly created ubuntu server box. 
# The objective is to create a bare bones development box that can be used for development using virtualbox.


#get the user name for which .profile should be modified
echo -n "Enter username: "
read current_user
apt-get update
apt-get install vim most --no-install-recommends 

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
	apt-get install gcc make xorg vim-gtk --no-install-recommends
	echo -n "Enter virtual box version number: (Eg. 4.1.16) "
	read vbox_version
	cd /tmp
	wget http://download.virtualbox.org/virtualbox/$vbox_version/VBoxGuestAdditions_$vbox_version.iso
	mount -o loop VBoxGuestAdditions_$vbox_version.iso /mnt
	sh /mnt/VBoxLinuxAdditions.run
	umount /mnt
	rm VBoxGuestAdditions_$vbox_version.iso
}


echo -n "Install Virtual box extension ? (Y/N)"
read choice
case $choice in
	[Yy]*) installVirtualBoxExt
		break;;
	*) break;;
esac


# Install XMonad, xmobar as the status bar and dmenu.
installXMonad(){
	apt-get install xmonad libghc-xmonad-dev libghc-xmonad-contrib-dev xmobar dmenu --no-install-recommends
	mkdir /home/$current_user/.xmonad
	chown $current_user /home/$current_user/.xmonad
	chgrp $current_user /home/$current_user/.xmonad
	wget https://raw.github.com/jman01/customizations/master/xmonad.hs
	mv xmonad.hs /home/$current_user/.xmonad/
	chown $current_user /home/$current_user/.xmonad/xmonad.hs
	chgrp $current_user /home/$current_user/.xmonad/xmonad.hs
	wget https://raw.github.com/jman01/customizations/master/xmobarrc
	mv xmobarrc /home/$current_user/.xmobarrc
	chown $current_user /home/$current_user/.xmobarrc
	chgrp $current_user /home/$current_user/.xmobarrc
}

echo -n "Install XMonad ? (Y/N)"
read choice
case $choice in
	[Yy]*) installXMonad
		break;;
	*) break;;
esac

