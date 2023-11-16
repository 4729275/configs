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
apt-get install -y audacity curl dbus-x11 exa flatpak fonts-roboto gimp gnome-console gnome-software-plugin-flatpak htop kleopatra neofetch nextcloud-desktop psensor scdaemon systemd-timesyncd systemd-zram-generator tilem timeshift ttf-mscorefonts-installer ufw vim virt-manager vlc wireguard-tools
apt-get remove -y firefox-esr gnome-terminal libreoffice*
apt-get autoremove -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.gtk.Gtk3theme.Adwaita-dark
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub us.zoom.Zoom
usermod -aG libvirt kenneth

# Install nvidia driver
echo "Installing nVIDIA driver:"
apt-get install nvidia-driver
echo 'GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nvidia-drm.modeset=1"' > /etc/default/grub.d/nvidia-modeset.cfg
update-grub
cp /usr/share/doc/xserver-xorg-video-nvidia/examples/nvidia-sleep.sh /usr/bin/
cp /usr/share/doc/xserver-xorg-video-nvidia/examples/system-sleep/nvidia /usr/lib/systemd/system-sleep
cp /usr/share/doc/xserver-xorg-video-nvidia/examples/system/nvidia-* /etc/systemd/system/
systemctl daemon-reload
systemctl enable nvidia-hibernate nvidia-resume nvidia-suspend
echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" > /etc/modprobe.d/nvidia-power-management.conf
ln -s /dev/null /etc/udev/rules.d/61-gdm.rules

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
