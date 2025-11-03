#! /usr/bin/bash

### Debian Laptop Setup Script ###
# Kenneth Simmons, 2025

echo "Debian Laptop Setup - Kenneth Simmons, 2025"

# Update the system
echo "Updating the system:"
sed -i 's/trixie/forky/g' /etc/apt/sources.list.d/*
apt-get update -y
apt-get full-upgrade -y

# Install packages
echo "Installing packages:"
apt-get install audacity eza fastfetch fonts-noto-cjk fonts-roboto gimp gnome-themes-extra handbrake htop inkscape kid3 mkvtoolnix-gui nextcloud-desktop obs-studio plymouth-themes psensor python3-tk texstudio timeshift tlp tlp-rdw ufw v4l2loopback-dkms vim virt-manager vlc wireguard xournalpp yt-dlp -y
flatpak install com.github.tchx84.Flatseal org.onlyoffice.desktopeditors -y
systemctl start ufw tlp
usermod -aG libvirt kenneth

# Configure firewall
echo "Configuring firewall:"
ufw default allow outgoing
ufw default deny incoming
ufw enable

# Configure tlp
echo "Configuring tlp:"
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

# Configure grub and plymouth
echo "Configuring grub and plymouth:"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/g' /etc/default/grub
if [ -f /etc/grub.d/05_debian_theme ]; then
rm /etc/grub.d/05_debian_theme
fi
update-grub
plymouth-set-default-theme -R bgrt

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
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

# Remove packages
echo "Removing packages:"
apt-get purge gnome-terminal -y
apt-get autoremove -y

echo "Complete!"
echo "Reboot the computer to finalize the changes."
