#!/bin/bash

echo
echo 'INSTALLING XFCE'
echo 

PACKAGES=(
    'xfce4'
    'xfce4-goodies'
    'lightdm'
    'lightdm-gtk-greeter'
)

pacman -Sq --noconfirm ${PACKAGES[@]} 

systemctl enable lightdm.service

echo "XFCE INSTALLED"