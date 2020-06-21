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