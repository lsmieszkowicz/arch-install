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

for PKG in "${PACKAGES[@]}" ; do 
    echo "Installing: $PKG "
    pacman -S $PKG --noconfirm
done

systemctl enable lightdm.service

echo "XFCE INSTALLED"