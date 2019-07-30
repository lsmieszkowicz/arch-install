#!/bin/bash

echo
echo 'INSTALLING DRIVERS AND XORG'
echo 

PACKAGES=(

    # DRIVERS
    'xf86-video-fbdev' 
    'xf86-video-vesa'
    'xf86-video-intel' 
    'mesa' 
    'xorg-xinput' 
    'xorg-xset'  
    'xf86-input-libinput'


    # XORG
    'xorg'
    'xorg-server'
    'xorg-apps'
    'xorg-xinit'

    # FONTS
    'ttf-bitstream-vera' 
    'ttf-dejavu' 
    'ttf-droid' 
    'ttf-roboto' 
    'noto-fonts' 
    'ttf-liberation'
)

for PKG in "${PACKAGES[@]}" ; do 
    echo "Installing: $PKG "
    pacman -S --no-confirm $PKG
done

echo "Xorg, drivers and fonts installed"