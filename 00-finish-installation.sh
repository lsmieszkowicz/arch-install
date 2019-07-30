#!/bin/bash

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