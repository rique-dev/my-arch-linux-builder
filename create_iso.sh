#!/bin/bash
set -e

# update
mirror
update
pksyua


echo "Deleting the build folder if one exists"
[ -d ./build/ ] && sudo rm -rf ./build/

echo "Coping files and folder to work folder"
sudo mkdir ./build/
sudo cp -rf ./src/* ./build/

echo "Checking if archiso is installed"

package="archiso"

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

echo "Copying files and folder to ./build as root"

sudo chmod 750 ./build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ./build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ./build/archiso/airootfs/etc/polkit-1/rules.d

cd ./build/archiso

echo "In order to build an iso we need to clean your cache"

yes | sudo pacman -Scc

echo "Building the iso"

sudo ./build.sh -v

echo "Moving the iso to ./iso"

[ -d  ~/iso ] || mkdir ~/iso
sudo cp ./build/archiso/out/* ~/iso

echo "Deleting the .tmp folder"

[ -d ./build/ ] && sudo rm -rf ./build/