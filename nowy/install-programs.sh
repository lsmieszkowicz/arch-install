#!/bin/bash

echo ""
echo 'INSTALUJE PODSTAWOWE PROGRAMY'
echo ""


# instalacja AUR helpera - yay
git clone https://aur.archlinux.org/yay
cd yay
makepkg -si 
cd ..
rm -rf yay

# lista programow do zainstalowania
PACKAGE_LIST=(
    # XORG
    xorg-server
    xorg-apps
    xf86-video-vesa
    xf86-video-intel
    mesa
    xf86-input-libinput
    xorg-xinit
    #
    #dzwiek
    alsa-utils
    pulseaudio
    pulseaudio-alsa
    #
    #czcionki
    ttf-bitstream-vera
    ttf-dejavu
    ttf-droid
    ttf-roboto
    ttf-liberation
    ttf-ubuntu-font-family
    noto-fonts
    ttf-fira-mono
    ttf-fira-code
    ttf-hack
    ttf-inconsolata
)

XFCE_LIST=(
    xfce4
    xfce4-goodies
    lightdm
    lightdm-gtk-greeter
)

I3_LIST=(
    i3
    ranger
    feh
    compton
    dunst
    arandr
    polybar
)


# instalacja
pacman -Sq --noconfirm ${PACKAGE_LIST[@]} 

# instalacja xfce
# yay -Sq --noconfirm ${XFCE_LIST[@]}
# sudo systemctl enable lightdm.service

# instalacja i3wm
#yay -Sq --noconfirm ${I3_LIST[@]}

# konfiguracja i wlaczenie uslug
amixer sset Master unmute
systemctl enable NetworkManager.service
systemctl start NetworkManager.service