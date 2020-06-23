#!/bin/bash


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