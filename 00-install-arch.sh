#!/bin/bash

vim /etc/pacman.d/mirrorlist
echo
echo "Do you want to install Arch Linux on your computer? [y/N]"
echo
read DEC

if [[ $DEC =~ [yY] ]] ; then 
    pacstrap /mnt base base-devel git vim networkmanager
else
     exit 1
fi

echo 'Generating fstab'
genfstab -U /mnt >> /mnt/etc/fstab

echo 'Changing root directory'
arch-chroot /mnt