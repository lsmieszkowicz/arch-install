#!/bin/bash

print_help() {
    echo 'Witaj w skrypcie instalacyjnym Arch Wiki'
    echo -e "-h --help \tPomoc"
    echo -e "--check-efi\tSprawdz dzialanie w trybie UEFI"
    echo -e "-p --partition\tPartycjonowanie dyskow"
    echo -e "-i --install\tInstalacja systemu"
    echo -e "-f --finalize\tCzynności po instalacji"
    echo -e "-u --user\tDodaj uzytkownika"
    echo -e "--grub-mbr\tZainstaluj bootloader GRUB"
    echo -e "--programs\tZainstaluj podstawowe programy"
    echo -e "--aur\t\tZainstaluj AUR helper Yay"
    echo -e "--vbox\t\tZainstaluj pakiety dla VirtualBoxa"
    echo -e "--xfce\t\tZainstaluj srodowisko XFCE"
    echo -e "--i3\t\tZainstaluj menedzer okien i3wm"
}

check_efi() {
    EFI=false
    ls /sys/firmware/efi/efivars && EFI=true 
    if [[ $EFI = true ]]; then
        echo "Tryb UEFI = on"
    else
        echo "Tryb UEFI = off"
    fi
}

partition() {
        # partycjonowanie dysków
    lsblk
    read -p "Ktory dysk partycjonowac: (np /dev/sda): " FDISK_DISK
    fdisk $FDISK_DISK

    # TODO
    # Dodać obsługę EFI

    # formatowanie partycji dla /
    lsblk
    read -p "Wybierz partycję dla katalogu glownego: " ROOT_DIR
    mkfs.ext4 $ROOT_DIR
    mount $ROOT_DIR /mnt


    # formatowanie partycji dla katalogu /home
    lsblk
    read -p "Czy utworzyc partycje /home? [y/n]: " USE_HOME
    if [[ $USE_HOME = 'y' ]]; then
        lsblk
        read -p "Wybierz partycje dla katalogu /home: " HOME_DIR
        mkfs.ext4 $HOME_DIR
        mount $HOME_DIR /home
    fi

    # tworzenie partycji swap
    read -p "Czy utworzyc partycje swap? [y/n]: " USE_SWAP
    if [[ $USE_SWAP = 'y' ]]; then
        lsblk
        read -p "Wybierz partycje swap: " SWAP_DIR
        mkswap $SWAP_DIR
        swapon $SWAP_DIR
    fi
}

install() {
    # czas systemowy
    timedatectl set-ntp true

    # wybor mirrorow
    vim /etc/pacman.d/mirrorlist

    ### INSTALACJA ###
    pacstrap /mnt base base-devel linux linux-firmware vim git networkmanager

    # fstab
    genfstab -U /mnt >> /mnt/etc/fstab    
}

finalize() {
    # ustawienie strefy czasowej
    ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
    hwclock --systohc

    # lokalizacja
    vim /etc/locale.gen
    locale-gen

    vim /etc/locale.conf
    vim /etc/vconsole.conf
    vim /etc/hosts
    # konfiguracja sieci
    read -p "Podaj nawzwe tego komputera: " HOST_NAME
    echo "$HOSTNAME" > /etc/hostname

    # initramfs
    mkinitcpio -P

    # haslo admina
    echo 'Podaj haslo roota'
    echo
    passwd root    
}

adduser() {
    read -p "Podaj nazwe uzytkownika: " USER_NAME
    useradd -g wheel -m -s /bin/bash $USER_NAME
    echo "Haslo dla uzytkownika: "
    passwd $USER_NAME
    visudo
}

grub_mbr() {
    pacman -Sq --noconfirm grub intel-ucode
    lsblk
    read -p "Gdzie zainstalowac GRUBA? (np. /dev/sda): " GRUB_DIR
    grub-install --target=i386-pc $GRUB_DIR
    grub-mkconfig -o /boot/grub/grub.cfg
    echo "GRUB zainstalowany"
}

aur_helper() {
    # instalacja AUR helpera - yay
    git clone https://aur.archlinux.org/yay
    cd yay
    makepkg -si 
    cd ..
    rm -rf yay
}

vbox() {
    pacman -Sq --noconfirm virtualbox-guest-utils xf86-video-vmware
    systemctl enable vboxservice.service
    VBoxClient-all
}

install_programs() {
    vim ./install-programs.sh
    ./install-programs.sh
}

install_xfce() {
    pacman -Sq --noconfirm xfce4 xfce4-goodies lightdm lightdm-gtk-greeter
}

install_i3() {
   I3_LIST=(
        i3
        ranger
        feh
        compton
        dunst
        arandr
        polybar
    )
    
    pacman -Sq --noconfirm ${I3_LIST[@]} 
}

case $1 in
    '-h'|'--help') print_help ;;
    '--check-efi') check_efi ;;
    '-p' | '--partition') partition ;;
    '-i' | '--install') install ;;
    '-f' | '--finalize') finalize ;;
    '-u' | '--user') adduser ;;
    '--grub-mbr') grub_mbr ;;
    '--programs') install_programs ;;
    '--aur') aur_helper ;;
    '--vbox') vbox ;;
    '--xfce') install_xfce ;;
    '--i3') install_i3 ;;
    *) print_help ;;
esac

