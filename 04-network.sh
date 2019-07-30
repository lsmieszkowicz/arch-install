#!/bin/bash

echo
echo 'INSTALLING NETWORK PACKAGES'
echo 

PACKAGES=(

    'networkmanager'

)

for PKG in "${PACKAGES[@]}" ; do 
    echo "Installing: $PKG "
    pacman -S --no-confirm $PKG
done

systemctl enable NetworkManager.service
systemctl start  NetworkManager.service

echo "Network packages installed and enabled"