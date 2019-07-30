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

echo 'Setting timezone and hardware clock'
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc --utc

echo 'Setting up locale'
vim /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=pl > /etc/vconsole.conf

echo 'Enter your hostname'
echo
read hostname
echo $hostname > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts

echo 'Enter administrator password:'
passwd root

mkinitcpio -p linux