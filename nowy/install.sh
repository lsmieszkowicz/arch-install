#!/bin/bash

# polski uklad klawiatury
loadkeys pl

# sprawdzamy czy jestesmy w trybie UEFI
EFI=false
ls /sys/firmware/efi/efivars && EFI=true 
if [[ $EFI = true ]]; then
    echo "Tryb UEFI wlaczony"
fi

read -p "Czy chcesz wykonac partycjonowanie? [y/n]: " RUN_PARTITION
if [[ $RUN_PARTITION = 'y' ]]; then
    ./partition.sh
fi

# czas systemowy
timedatectl set-ntp true

# wybor mirrorow
vim /etc/pacman.d/mirrorlist

### INSTALACJA ###
pacstrap /mnt base base-devel linux linux-firmware vim git networkmanager

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

echo ""
echo "Zakonczono pierwszy etap instalacji"
echo ""

cp -r ./* /mnt/arch-install/