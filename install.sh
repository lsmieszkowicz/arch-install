#!/bin/bash

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

vim /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
echo KEYMAP=pl > /etc/vconsole.conf

echo 'Set your machine name:'
read hostname
echo $hostname > /etc/hostname
echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1       localhost' >> /etc/hosts
mkinitcpio -p linux
passwd root

echo 'Type your username:'
read username
useradd -m -g users -G wheel,power,storage,input -s /bin/bash $username
passwd $username

visudo

pacman -S xorg-server xorg-apps xf86-video-fbdev xf86-video-vesa xf86-video-intel mesa xorg-xinit xorg-xinput xorg-xset  xf86-input-libinput xorg-xinput lightdm lightdm-gtk-greeter i3 dmenu rxvt-unicode ttf-bitstream-vera ttf-dejavu ttf-droid ttf-roboto noto-fonts ttf-liberation alsa-utils pulseaudio pulseaudio-alsa pavucontrol networkmanager arandr dunst compton feh

systemctl enable lightdm.service
systemctl enable NetworkManager.service

amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute

pacman -S firefox
