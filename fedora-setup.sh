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
dnf install rpmfusion-free-appstream-data rpmfusion-nonfree-appstream-data -y
dnf swap ffmpeg-free ffmpeg --allowerasing -y
dnf update @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin -y
dnf install intel-media-driver -y
dnf install adw-gtk3-theme eza fastfetch gimp gnome-tweaks google-noto-sans-cjk-fonts google-roboto-fonts htop inkscape java-latest-openjdk kid3 kmod-v4l2loopback nextcloud-client nodejs24 obs-studio python3-tkinter qemu rhythmbox texlive-collection-latex texstudio vim-enhanced virt-manager vlc wireguard-tools xournalpp yt-dlp -y
flatpak install -y flathub com.github.tchx84.Flatseal io.github.realmazharhussain.GdmSettings org.jellyfin.JellyfinDesktop org.onlyoffice.desktopeditors net.nokyan.Resources
AUDACITY_VERSION=4.0.1
CHIRP_VERSION=20261002
if [ ! -d /home/kenneth/.local/share/applications ]; then
mkdir /home/kenneth/.local/share/applications
fi
wget https://github.com/audacity/audacity/releases/download/Audacity-${AUDACITY_VERSION}/audacity-linux-${AUDACITY_VERSION}-x86_64.AppImage
mv audacity-linux-${AUDACITY_VERSION}-x86_64.AppImage Audacity4.AppImage
cp Audacity4.AppImage /opt/
cp Audacity4.svg /opt/
cp Audacity4.desktop /home/kenneth/.local/share/applications
chown kenneth:kenneth /opt/Audacity4.AppImage
chmod a+x /opt/Audacity4.AppImage
chown kenneth:kenneth /opt/Audacity4.svg
wget https://archive.chirpmyradio.com/chirp_next/next-${CHIRP_VERSION}/Chirp-next-${CHIRP_VERSION}-x86_64.AppImage
mv Chirp-next-${CHIRP_VERSION}-x86_64.AppImage CHIRP.AppImage
cp CHIRP.AppImage /opt/
cp CHIRP.ico /opt/
cp CHIRP.desktop /home/kenneth/.local/share/applications
chown kenneth:kenneth /opt/CHIRP.AppImage
chmod a+x /opt/CHIRP.AppImage
chown kenneth:kenneth /opt/CHIRP.ico
chown -R kenneth:kenneth /home/kenneth/.local/share/applications
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
echo "--js-runtimes node" >> /etc/yt-dlp.conf
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
echo "alias wgupf='sudo wg-quick up family'" >> /home/kenneth/.bash_aliases
echo "alias wgdnf='sudo wg-quick down family'" >> /home/kenneth/.bash_aliases
echo "alias wgupk='sudo wg-quick up kenneth'" >> /home/kenneth/.bash_aliases
echo "alias wgdnk='sudo wg-quick down kenneth'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

echo "Complete!"
echo "Reboot the computer to finalize the changes."
