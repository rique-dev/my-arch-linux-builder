#!/bin/bash
#set -e

echo
echo "################################################################## "
echo "Phase 1 : get the latest bashrc from github"
echo "################################################################## "
echo
echo "Removing old files/folders from folder"
rm -rf ../archiso/airootfs/etc/skel/.* 2> /dev/null
echo "getting .bashrc from archlinux-root"
wget https://raw.githubusercontent.com/archlinux/archlinux-root/master/root/.bashrc-latest -O ../archiso/airootfs/etc/skel/.bashrc
echo ".bashrc copied to /etc/skel"


echo
echo "################################################################## "
echo "Phase 2 : Checking if archiso is installed"
echo "################################################################## "
echo
echo "Checking if archiso is installed"

package="archiso"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		trizen -S --noconfirm --needed --noedit $package

	elif pacman -Qi yaourt &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yaourt"
		echo "################################################################"
		yaourt -S --noconfirm $package

	elif pacman -Qi pacaur &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with pacaur"
		echo "################################################################"
		pacaur -S --noconfirm --noedit  $package

	elif pacman -Qi packer &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with packer"
		echo "################################################################"
		packer -S --noconfirm --noedit  $package

	fi

	# Just checking if installation was successful
	if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "#########  "$package" has been installed"
		echo "################################################################"

	else

		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!!  "$package" has NOT been installed"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

	fi

fi


echo
echo "################################################################## "
echo "Phase 3 : Making sure we start with a clean slate"
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d ~/archlinux-build ] && sudo rm -rf ~/archlinux-build


echo
echo "################################################################## "
echo "Phase 4 : Moving files to archlinux-build folder"
echo "################################################################## "
echo
echo "Copying files and folder to ~/archlinux-build"
sudo cp -r ../../archlinux-iso ~/archlinux-build

sudo chmod 750 ~/archlinux-build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ~/archlinux-build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ~/archlinux-build/archiso/airootfs/etc/polkit-1/rules.d

echo
echo "################################################################## "
echo "Phase 5 : Cleaning the cache"
echo "################################################################## "
echo
yes | sudo pacman -Scc


echo
echo "################################################################## "
echo "Phase 6 : Building the iso"
echo "################################################################## "
echo

cd ~/archlinux-build/archiso/
sudo ./build.sh -v

echo
echo "################################################################## "
echo "Phase 7 : Copying the iso to ~/ArchLinux-Out"
echo "################################################################## "
echo
[ -d  ~/ArchLinux-Out ] || mkdir ~/ArchLinux-Out
cp ~/archlinux-build/archiso/out/archlinux* ~/ArchLinux-Out
