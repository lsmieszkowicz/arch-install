#!/bin/bash

echo 'Type new user name:'
read username
useradd -m -g users -G wheel,power,storage,input -s /bin/bash $username
echo
echo 'Type new user password:'
passwd $username

visudo