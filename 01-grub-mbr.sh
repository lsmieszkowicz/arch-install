#!/bin/bash

echo
echo "Installing Intel Micorcode"
pacman -S --no-confirm intel-ucode

echo
echo "Instaling grub"
pacman -S --no-confirm grub

echo "Where to install GRUB?"
read GRUB_PATH

lsblk
grub-install $GRUB_PATH
grub-mkconfig -o /boot/grub/grub.cfg