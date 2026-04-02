#! /usr/bin/bash

### Fedora Laptop Setup Script ###
# Kenneth Simmons, 2026

echo "Fedora Laptop Setup - Kenneth Simmons, 2026"

# Set hostname
echo "Setting hostname:"
echo "Enter hostname:"
read hostname
hostnamectl hostname $hostname

# Enable NTP
echo "Enabling NTP:"
systemctl enable --now systemd-timesyncd

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
dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf install intel-media-driver -y
dnf install adw-gtk3-theme audacity eza fastfetch gimp gnome-tweaks google-noto-sans-cjk-fonts google-roboto-fonts htop inkscape kid3 kmod-v4l2loopback nextcloud-client obs-studio python3-tkinter qemu rhythmbox texstudio vim-enhanced virt-manager vlc wireguard-tools xournalpp yt-dlp -y
flatpak install -y flathub com.github.tchx84.Flatseal com.google.EarthPro io.github.realmazharhussain.GdmSettings org.jellyfin.JellyfinDesktop org.onlyoffice.desktopeditors
flatpak override --env=QT_DEVICE_PIXEL_RATIO=2 com.google.EarthPro
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
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

# Configure yt-dlp
echo "Configuring yt-dlp:"
if [ -f /etc/yt-dlp.conf ]; then
mv /etc/yt-dlp.conf /etc/yt-dlp.conf.bak
fi
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format opus" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf
echo "--cookies-from-browser firefox" >> /etc/yt-dlp.conf
echo "--remote-components ejs:github" >> /etc/yt-dlp.conf

# Create bash aliases
echo "Creating bash aliases:"
if [ ! -f /home/kenneth/.bash_aliases ]; then
cp /home/kenneth/.bashrc /home/kenneth/.bashrc.bak
chown kenneth:kenneth /home/kenneth/.bashrc.bak
echo "if [ -f ~/.bash_aliases ]; then" >> /home/kenneth/.bashrc
echo ". ~/.bash_aliases" >> /home/kenneth/.bashrc
echo "fi" >> /home/kenneth/.bashrc
echo "alias dnfup='sudo dnf upgrade && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

echo "Complete!"
echo "Reboot the computer to finalize the changes."
