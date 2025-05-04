#! /usr/bin/bash

### Fedora Laptop Setup Script ###
# Kenneth Simmons, 2025

echo "Fedora Laptop Setup - Kenneth Simmons, 2025"

# Set hostname
echo "Setting hostname:"
echo "Enter hostname:"
read hostname
hostnamectl hostname $hostname

# Update the system
echo "Updating the system:"
dnf upgrade -y
flatpak update

# Install packages
echo "Installing packages:"
dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y
dnf config-manager setopt fedora-cisco-openh264.enabled=1
dnf install rpmfusion-\*-appstream-data -y
dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf --setopt=install_weak_deps=False update @multimedia --exclude=PackageKit-gstreamer-plugin -y
dnf install intel-media-driver -y
dnf copr enable alternateved/eza -y
dnf install audacity eza fastfetch gimp gnome-themes-extra gnome-tweaks google-noto-sans-cjk-fonts google-roboto-fonts handbrake htop inkscape kid3 kleopatra mkvtoolnix-gui nextcloud-client obs-studio python3-tkinter qemu texstudio timeshift tlp tlp-rdw v4l-utils vim-enhanced virt-manager vlc wireguard-tools xournalpp xsensors yt-dlp -y
flatpak install -y flathub com.github.tchx84.Flatseal com.google.EarthPro org.onlyoffice.desktopeditors us.zoom.Zoom
systemctl enable --now libvirtd
usermod -aG libvirt kenneth

# Configure dnf
echo "Configuring dnf:"
if [ ! -f /etc/dnf/dnf.conf.bak ]; then
cp /etc/dnf/dnf.conf /etc/dnf/dnf.conf.bak
echo "defaultyes=True" >> /etc/dnf/dnf.conf
fi

# Configure firewall
echo "Configuring firewall:"
dnf remove firewalld -y
dnf install ufw -y
systemctl enable --now ufw
ufw default allow outgoing
ufw default deny incoming
ufw enable

# Configure tlp
echo "Configuring tlp:"
systemctl enable --now tlp
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

# Configure yt-dlp
echo "Configuring yt-dlp:"
if [ -f /etc/yt-dlp.conf ]; then
mv /etc/yt-dlp.conf /etc/yt-dlp.conf.bak
fi
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format best" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf

# Create bash aliases
echo "Creating bash aliases:"
if [ ! -f /home/kenneth/.bash_aliases ]; then
cp /home/kenneth/.bashrc /home/kenneth/.bashrc.bak
chown kenneth:kenneth /home/kenneth/.bashrc.bak
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias dnfup='sudo dnf upgrade && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

echo "Complete!"
echo "Reboot the computer to finalize the changes."
