echo
echo 'INSTALUJE PODSTAWOWE PROGRAMY'
echo 

PACKAGE_LIST (
    # XORG
    xorg-server
    xorg-apps
    xf86-video-vesa
    xf86-video-intel
    mesa
    xf86-input-libinput
    xorg-xinit

    #dzwiek
    alsa-utils
    pulseaudio
    pulseaudio-alsa

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

for PKG in ${PACKAGE_LIST[@]};
do
    echo "Instaluję: $PKG "
    pacman -Sq $PKG --noconfirm
done

# konfiguracja
amixer sset Master unmute
systemctl enable NetworkManager.service
systemctl start NetworkManager.service
