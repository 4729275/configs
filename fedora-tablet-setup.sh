#! /bin/bash

### Fedora Tablet Setup Script ###
# Kenneth Simmons, 2024

echo "Fedora Tablet Setup - Kenneth Simmons, 2024"

# Configure dnf
echo "Configuring dnf:"
echo "defaultyes=True" >> /etc/dnf/dnf.conf
echo "keepcache=True" >> /etc/dnf/dnf.conf
echo "max_parallel_downloads=5" >> /etc/dnf/dnf.conf

# Install linux-surface
echo "Installing linux-surface:"
dnf config-manager --add-repo=https://pkg.surfacelinux.com/fedora/linux-surface.repo
dnf install --allowerasing kernel-surface iptsd libwacom-surface -y
dnf install surface-secureboot -y
systemctl enable --now linux-surface-default-watchdog.path
linux-surface-default-watchdog.sh

# Update the system
echo "Updating the system:"
dnf upgrade -y

# Enable RPM Fusion:
echo "Enabling RPM Fusion:"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf groupupdate core -y

# Installing packages
echo "Installing packages:"
dnf install cabextract eza gnome-console gnome-themes-extra gnome-tweaks google-roboto-fonts htop kleopatra neofetch nextcloud-client snapshot timeshift tlp tlp-rdw vim-enhanced vlc wireguard-tools xorg-x11-font-utils xournalpp xsensors -y
rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
flatpak install flathub org.kde.krita org.onlyoffice.desktopeditors us.zoom.Zoom -y
dnf remove power-profiles-daemon -y

# Create bash aliases
echo "Creating bash aliases:"
echo "Configuring bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
echo "alias dnfup='sudo dnf upgrade && flatpak update'" >> /home/kenneth/.bash_aliases

# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=45s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=45s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

# Configure tlp
systemctl enable --now tlp
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

# Enable systemd-timesyncd
echo "Enabling systemd-timesyncd"
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
