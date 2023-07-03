#! /bin/bash

### Fedora Laptop Setup Script ###
# Kenneth Simmons, 2023

echo "Fedora Laptop Setup - Kenneth Simmons, 2023"

# Configure DNF
echo "Configuring DNF:"
echo "fastestmirror=True" | tee -a /etc/dnf/dnf.conf
echo "max_parallel_downloads=5" | tee -a /etc/dnf/dnf.conf
echo "defaultyes=True" | tee -a /etc/dnf/dnf.conf
echo "keepcache=True" | tee -a /etc/dnf/dnf.conf

# Update the system
echo "Updating the system:"
dnf update -y

# Enable RPM Fusion
echo "Enabling RPM Fusion:"
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core

# Set hostname
echo "Setting hostname:"
read hostname
hostnamectl set-hostname $hostname

# Enable multimedia codecs
echo "Enabling multimedia codecs:"
dnf swap -y ffmpeg-free ffmpeg --allowerasing
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf install -y intel-media-driver

# Install packages
echo "Installing packages:"
dnf install -y audacity exa file-roller gimp gnome-extensions-app gnome-tweaks google-roboto-fonts htop kleopatra neofetch nextcloud-client thunderbird tilem timeshift vim-enhanced vlc wireguard-tools xsensors
flatpak install -y flathub com.github.GradienceTeam.Gradience
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub us.zoom.Zoom

# Configure bash prompt
echo "Configuring bash prompt:"
echo "PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '" | tee -a /home/kenneth/.bashrc

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
echo "alias dnfup='sudo dnf update && flatpak update'" | tee -a /home/kenneth/.bash_aliases

# Fix display issues
echo "Fixing display issues:"
if [ -f /etc/modprobe.d/i915.conf ]; then
	rm /etc/modprobe.d/i915.conf
fi
touch /etc/modprobe.d/i915.conf
echo "options i915 enable_psr=0" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_guc=3" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_fbc=1" | tee -a /etc/modprobe.d/i915.conf
dracut --force

# Enable fractional scaling
echo "Enabling fractional scaling:"
su kenneth
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

echo "Complete!"
echo "Reboot the computer to finalize the changes."
