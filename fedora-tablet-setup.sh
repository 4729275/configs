#! /bin/bash

### Fedora Tablet Setup Script ###
# Kenneth Simmons, 2023

echo "Fedora Tablet Setup - Kenneth Simmons, 2023"

# Configure DNF
echo "Configuring DNF:"
echo "fastestmirror=True" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=5" | tee -a /etc/dnf/dnf.conf
echo "defaultyes=True" | tee -a /etc/dnf/dnf.conf
echo "keepcache=True" | tee -a /etc/dnf/dnf.conf

# Update the system
echo "Updating the system:"
dnf update -y

# Install linux-surface
echo "Installing linux-surface:"
dnf config-manager -y --add-repo=https://pkg.surfacelinux.com/fedora/linux-surface.repo
dnf install -y --allowerasing kernel-surface iptsd libwacom-surface
dnf install -y surface-secureboot
touch /etc/systemd/system/default-kernel.path
echo "[Unit]" | tee -a /etc/systemd/default-kernel.path
echo "Description=Fedora default kernel updater" | tee -a /etc/systemd/default-kernel.path
echo "[Path]" | tee -a /etc/systemd/default-kernel.path
echo "PathChanged=/boot" | tee -a /etc/systemd/default-kernel.path
echo "[Install]" | tee -a /etc/systemd/default-kernel.path
echo "WantedBy=default.target" | tee -a /etc/systemd/default-kernel.path
touch /etc/systemd/system/default-kernel.service
echo "[Unit]" | tee -a /etc/systemd/default-kernel.service
echo "Description=Fedora default kernel updater" | tee -a /etc/systemd/default-kernel.service
echo "[Service]" | tee -a /etc/systemd/default-kernel.service
echo "Type=oneshot" | tee -a /etc/systemd/default-kernel.service
echo "ExecStart=/bin/sh -c \"grubby --set-default /boot/vmlinuz*surface*\"" | tee -a /etc/systemd/default-kernel.service
systemctl enable default-kernel.path
grubby --set-default /boot/vmlinuz*surface*

# Enable RPM Fusion
echo "Enabling RPM Fusion:"
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core

# Enable Flathub
echo "Enabling Flathub:"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Set hostname
echo "Setting hostname:"
read hostname
hostnamectl set-hostname $hostname

# Enable multimedia codecs
echo "Enabling multimedia codecs:"
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf install -y intel-media-driver

# Install packages
echo "Installing packages:"
dnf install -y exa gnome-extensions-app gnome-tweaks google-roboto-fonts htop kleopatra krita neofetch nextcloud-client vim-enhanced wireguard-tools xournalpp xsensors
flatpak install -y flathub com.github.GradienceTeam.Gradience

# Create bash aliases
echo "Creating bash aliases:"
echo "if [ -f ~/.bash_aliases ]; then" | tee -a /home/kenneth/.bashrc
echo ". ~/.bash_aliases" | tee -a /home/kenneth/.bashrc
echo "fi" | tee -a /home/kenneth/.bashrc
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias khome='ssh -i \$HOME/.ssh/kenneth-home -p 314 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases
echo "alias dnfup='sudo dnf update'" | tee -a /home/kenneth/.bash_aliases

echo "Complete!"
echo "Reboot the computer to finalize the changes."
