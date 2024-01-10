#! /bin/bash

### Debian Tablet Setup Script ###
# Kenneth Simmons, 2023

echo "Debian Tablet Setup - Kenneth Simmons, 2023"

# Install linux-surface
echo "Installing linux-surface:"
apt-get update
apt-get install -y wget
wget -qO - https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | gpg --dearmor | dd of=/etc/apt/trusted.gpg.d/linux-surface.gpg
echo "deb [arch=amd64] https://pkg.surfacelinux.com/debian release main" | tee /etc/apt/sources.list.d/linux-surface.list
apt-get update
apt-get install -y linux-image-surface linux-headers-surface libwacom-surface iptsd
apt-get install -y linux-surface-secureboot-mok
update-grub

# Install packages
echo "Installing packages:"
apt-get install -y curl dbus-x11 exa flatpak fonts-roboto gnome-console gnome-software-plugin-flatpak htop kleopatra neofetch nextcloud-desktop psensor scdaemon systemd-timesyncd systemd-zram-generator ttf-mscorefonts-installer ufw vim wireguard-tools xournalpp
apt-get remove -y firefox-esr gnome-terminal libreoffice*
apt-get autoremove -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.kde.krita
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
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
echo "alias wgup='sudo wg-quick up home'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" | tee -a /home/kenneth/.bash_aliases
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

# Installing systemd-resolved
echo "Installing systemd-resolved:"
apt-get install -y systemd-resolved
systemctl enable --now systemd-resolved

echo "Complete!"
echo "Reboot the computer to finalize the changes."
