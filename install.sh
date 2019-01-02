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


pacman -S intel-ucode 
pacman -S grub efibootmgr

echo 'Please insert EFI partition path:'
read esp
mkdir /mnt/boot/efi
mount $esp /mnt/boot/efi
grub-install --target=x86_64-efi --efi-directory=$esp --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S os-prober
echo 'Type path to windows partition'
read winpart
mkdir /mnt/win $winpart
os-prober
grub-mkconfig -o /boot/grub/grub.cfg

echo 'Type your username:'
read username
useradd -m -g users -G wheel,power,storage,input -s /bin/bash $username

visudo

pacman -S xorg-server xorg-apps xf86-video-fbdev xf86-video-vesa xf86-video-intel mesa xorg-xinit xorg-xinput xorg-xset  xf86-input-libinput xorg-xinput
echo 'Installed xorg and drivers'

pacman -S lightdm lightdm-gtk-greeter
systemctl enable lightdm.service
echo 'Installed and enabled display manager'

pacman -S i3 dmenu rxvt-unicode
echo 'Installed dmenu and terminal emulator'

pacman -S ttf-bitstream-vera ttf-dejavu ttf-droid ttf-roboto noto-fonts ttf-liberation 
echo 'Installed fonts' 

pacman -S alsa-utils pulseaudio pulseaudio-alsa pavucontrol
amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute
echo 'Installed and set up audio'

pacman -S networkmanager
systemctl enable NetworkManager.service
echo 'Instaled and enabled Network Manager'

pacman -S arandr dunst compton feh
echo 'Installed utilities'

