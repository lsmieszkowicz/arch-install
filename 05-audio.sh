#!/bin/bash

echo
echo 'INSTALLING AUDIO PACKAGES'
echo 

PACKAGES=(

    'alsa-utils' 
    'pulseaudio' 
    'pulseaudio-alsa' 
    'pavucontrol'

)

for PKG in "${PACKAGES[@]}" ; do 
    echo "Installing: $PKG "
    pacman -S --no-confirm $PKG
done

amixer sset Master unmute
amixer sset Speaker unmute
amixer sset Headphone unmute

echo "Audio packages installed"