#!/bin/bash

# polski uklad klawiatury
loadkeys pl

# sprawdzamy czy jestesmy w trybie UEFI
# EFI=false
# ls /sys/firmware/efi/efivars && EFI=true 
# if [[ $EFI = true]]; then
#     echo "Tryb UEFI wlaczony"
# fi


# czas systemowy
timedatectl set-ntp true

# partycjonowanie dysków
lsblk
read -p "Ktory dysk partycjonowac: (np /dev/sda): " FDISK_DISK
fdisk $FDISK_DISK

# formatowanie partycji moze przeniesc do osobnej funkcji ?
# albo w ogole dac sobie z tym spokoj
# do dalszego zastanowienia sie

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

read -p "Czy utworzyc partycje swap? [y/n]: " USE_SWAP
if [[ $USE_SWAP = 'y' ]]; then
    lsblk
    read -p "Wybierz partycje swap: " SWAP_DIR
    mkswap $SWAP_DIR
    swapon $SWAP_DIR
fi
# wybor mirrorow
vim /etc/pacman.d/mirrorlist

### INSTALACJA
pacstrap /mnt base base-devel linux linux-firmware vim git networkmanager

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

echo ""
echo "Zakonczono pierwszy etap instalacji"
echo ""

cp . /mnt/arch-install
arch-chroot /mnt /arch-install/finish-install.sh