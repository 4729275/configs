#! /bin/bash

### Debian Laptop Setup Script ###
# Kenneth Simmons, 2023

echo "Debian Laptop Setup - Kenneth Simmons, 2023"

# Configure APT
echo "Configuring APT:"
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

# Update the system
echo "Updating the system:"
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# Install packages
echo "Installing packages:"
apt-get install -y audacity curl dbus-x11 exa flatpak fonts-roboto gimp gnome-console gnome-software-plugin-flatpak htop kleopatra neofetch nextcloud-desktop plymouth plymouth-themes psensor scdaemon systemd-timesyncd systemd-zram-generator tilem timeshift ttf-mscorefonts-installer ufw vim virt-manager vlc wireguard-tools
apt-get remove -y firefox-esr gnome-terminal libreoffice*
apt-get autoremove -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y flathub com.usebottles.bottles
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub us.zoom.Zoom
usermod -aG libvirt kenneth

# Setup swap-on-zram
echo "Setting up swap-on-zram:"
echo "zram-size = min(ram, 8192)" | tee -a /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" | tee -a /etc/systemd/zram-generator.conf

# Configure GRUB
echo "Configuring GRUB:"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
sed -i 's/#GRUB_GFXMODE=640x480/GRUB_GFXMODE=2240x1400/g' /etc/default/grub
update-grub

# Configure Plymouth
echo "Configuring Plymouth:"
plymouth-set-default-theme -R bgrt

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

# Fix display issues
echo "Fixing display issues:"
if [ -f /etc/modprobe.d/i915.conf ]; then
	rm /etc/modprobe.d/i915.conf
fi
touch /etc/modprobe.d/i915.conf
echo "options i915 enable_psr=0" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_guc=3" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_fbc=1" | tee -a /etc/modprobe.d/i915.conf
update-initramfs -u

# Installing systemd-resolved
echo "Installing systemd-resolved:"
apt-get install -y systemd-resolved
systemctl enable --now systemd-resolved

echo "Complete!"
echo "Reboot the computer to finalize the changes."
