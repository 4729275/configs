#! /bin/bash

### Ubuntu Laptop Setup Script ###
# Kenneth Simmons, 2024

echo "Ubuntu Laptop Setup - Kenneth Simmons, 2024"

# Update the system
echo "Updating the system:"
apt-get update -y
apt-get upgrade -y
apt-get autoremove -y
snap refresh

# Install packages
echo "Installing packages:"
add-apt-repository ppa:slimbook/slimbook -y
apt-get install audacity eza fonts-roboto gimp gnome-calendar gnome-console gnome-snapshot gnome-tweaks gnome-weather htop inkscape kleopatra libreoffice nextcloud-desktop psensor rhythmbox slimbookface texstudio tilem timeshift tlp tlp-rdw ttf-mscorefonts-installer vim virt-manager vlc wireguard xournalpp -y
wget http://http.us.debian.org/debian/pool/main/libf/libfprint/libfprint-2-2_1.94.8-1_amd64.deb
apt-get install ./libfprint-2-2_1.94.8-1_amd64.deb -y
rm libfprint-2-2_1.94.8-1_amd64.deb
snap install zoom-client

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo snap refresh'" >> /home/kenneth/.bash_aliases

# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

# Configure grub
echo "Configuring grub:"
echo "GRUB_HIDDEN_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_RECORDFAIL_TIMEOUT=0" >> /etc/default/grub
sed -i 's/OS_PROBER=true/OS_PROBER=false/g' /etc/default/grub
sed -i 's/quick_boot="1"/quick_boot="0"/g' /etc/grub.d/30_os-prober
sed -i 's/set timeout=10/#set timeout=10/g' /etc/grub.d/30_os-prober
update-grub

# Configure tlp
echo "Configuring tlp:"
systemctl enable --now tlp
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

# Configure howdy
echo "Configuring howdy:"
sed -i 's/device_path = none/device_path = \/dev\/video2/g' /usr/lib64/security/howdy/config.ini
sed -i 's/dark_threshold = 60/dark_threshold = 85/g' /usr/lib64/security/howdy/config.ini

# Remove packages:
echo "Removing packages:"
apt-get remove gnome-terminal -y
apt-get autoremove

echo "Complete!"
echo "Reboot the computer to finalize the changes."
