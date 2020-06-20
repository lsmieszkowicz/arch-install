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

read -p "Wybierz partycje swap: " SWAP_DIR
mkswap $SWAP_DIR
swapon $SWAP_DIR

# wybor mirrorow
vim /etc/pacman.d/mirrorlist

### INSTALACJA
pacstrap /mnt base base-devel linux linux-firmware vim git networkmanager

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# zmiana roota
arch-chroot /mnt

# ustawienie strefy czasowej
ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
hwclock --systohc

# lokalizacja
vim /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=pl" > /etc/vconsole.conf

# konfiguracja sieci
read -p "Podaj nawzwe tego komputera: " HOST_NAME
echo "$HOSTNAME" > /etc/HOSTNAME

echo "127.0.0.1    localhost" >> /etc/hosts

# initramfs
mkinitcpio -P

# haslo admina
passwd root

# GRUB
pacman -Sq grub intel-ucode
lsblk
read -p "Gdzie zainstalowac GRUBA? (np. /dev/sda): " GRUB_DIR
grub-install --terget=i386-pc $GRUB_DIR
grub-mkconfig -o /boot/grub/grub.cfg
echo "GRUB zainstalowany"

# dodawanie nowego uzytkownika
read -p "Podaj nazwe uzytkownika: " USER_NAME
useradd -g users -G wheel,storage,power,input -m -s /bin/bash $USER_NAME
echo "Haslo dla uzytkownika: "
passwd $USER_NAME
visudo

# instalacja programow
./install-base.sh
#./install-programs.sh
#./install-wm.sh

# konczenie instalacji
exit
umount -R /mnt
reboot

