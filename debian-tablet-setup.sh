#! /bin/bash

### Debian Tablet Setup Script ###
# Kenneth Simmons, 2023

echo "Debian Tablet Setup - Kenneth Simmons, 2023"

# Configure APT
echo "Configuring APT:"
sed -i '1,2d' /etc/apt/sources.list

# Update the system
echo "Updating the system:"
apt update -y && apt full-upgrade -y && apt autoremove -y

# Install linux-surface
echo "Installing linux-surface:"
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" | tee /etc/apt/sources.list.d/linux-surface.list
apt update -y
apt install -y linux-image-surface linux-headers-surface libwacom-surface iptsd
apt install -y linux-surface-secureboot-mok
apt install -y firmware-atheros surface-ath10k-firmware-override
update-grub

# Install packages
echo "Installing packages:"
apt install -y curl dbus-x11 exa flatpak fonts-roboto gnome-console gnome-software-plugin-flatpak htop kleopatra neofetch nextcloud-desktop psensor systemd-resolved systemd-zram-generator ttf-mscorefonts-installer ufw vim wireguard-tools xournalpp
apt remove -y firefox-esr gnome-terminal libreoffice*
apt autoremove -y
systemctl enable --now systemd-resolved
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.kde.krita
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub org.mozilla.Thunderbird
flatpak install -y flathub us.zoom.Zoom

# Setup swap-on-zram
echo "Setting up swap-on-zram:"
echo "zram-size = min(ram, 8192)" | tee -a /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" | tee -a /etc/systemd/zram-generator.conf

# Configure GRUB
echo "Configuring GRUB:"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
update-grub

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias khome='ssh -i \$HOME/.ssh/kenneth-home -p 314 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && flatpak update'" | tee -a /home/kenneth/.bash_aliases

# Configure firewall
echo "Configuring firewall:"
systemctl enable --now ufw
ufw default allow outgoing
ufw default deny incoming
ufw enable

# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

echo "Complete!"
echo "Reboot the computer to finalize the changes."
