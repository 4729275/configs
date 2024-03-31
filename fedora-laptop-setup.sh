#! /bin/bash

### Fedora Laptop Setup Script ###
# Kenneth Simmons, 2024

echo "Fedora Laptop Setup - Kenneth Simmons, 2024"

# Configure dnf
echo "Configuring dnf:"
echo "defaultyes=True" >> /etc/dnf/dnf.conf
echo "keepcache=True" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=5" >> /etc/dnf/dnf.conf

# Update the system
echo "Updating the system:"
dnf upgrade -y

# Enable RPM Fusion
echo "Enabling RPM Fusion:"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf groupupdate core -y

# Install multimedia codecs
echo "Installing multimedia concecs:"
dnf group install Multimedia --allowerasing

# Installing packages
echo "Installing packages:"
dnf install audacity cabextract eza gimp gnome-console gnome-themes-extra gnome-tweaks google-roboto-fonts htop inkscape kleopatra neofetch nextcloud-client snapshot tilem timeshift tlp tlp-rdw vim-enhanced virt-manager vlc wireguard-tools xorg-x11-font-utils xsensors -y
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
flatpak install flathub org.onlyoffice.desktopeditors com.google.EarthPro us.zoom.Zoom -y
dnf remove power-profiles-daemon -y
usermod -aG libvirt kenneth

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
echo "alias dnfup='sudo dnf upgrade && flatpak update'" >> /home/kenneth/.bash_aliases

# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=45s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=45s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

# Fix display issues
echo "Fixing display issues:"
if [ -f /etc/modprobe.d/i915.conf ]; then
	rm /etc/modprobe.d/i915.conf
fi
touch /etc/modprobe.d/i915.conf
echo "options i915 enable_psr=0" >> /etc/modprobe.d/i915.conf
echo "options i915 enable_guc=3" >> /etc/modprobe.d/i915.conf
echo "options i915 enable_fbc=1" >> /etc/modprobe.d/i915.conf
dracut --force

# Configure tlp
echo "Configuring tlp:"
systemctl enable --now tlp
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

# Enable systemd-timesyncd
echo "Enabling systemd-timesyncd:"
systemctl enable --now systemd-timesyncd

# Set hostname
echo "Setting hostname:"
echo "Enter hostname:"
read hostname
hostnamectl hostname $hostname

# Remove packages
echo "Removing packages:"
dnf remove gnome-terminal cheese -y

echo "Complete!"
echo "Reboot the computer to finalize the changes."
