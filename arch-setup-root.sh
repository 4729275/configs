#! /usr/bin/bash

### Arch Linux Setup Script, Root Portion ###
# Kenneth Simmons, 2026

echo "Arch Linux Setup, Root Portion - Kenneth Simmons, 2026"

# Install packages
echo "Installing packages:"
pacman -Sy --noconfirm audacity cdrdao cdrtools devede dnsmasq dvd+rw-tools eza fastfetch firefox gimp handbrake hplip htop inetutils inkscape jre-openjdk k3b kid3 lib32-vulkan-radeon libaacs libdvdcss libgpod libreoffice-fresh mkvtoolnix-gui musescore nextcloud-client obs-studio plymouth qemu-full qt6-multimedia-ffmpeg qt6-wayland reflector rhythmbox rpi-imager rust snapper steam texlive-latex texstudio tk transmission-gtk ttf-liberation ttf-roboto udftools ufw v4l2loopback-dkms virt-manager virtualbox virtualbox-guest-iso virtualbox-host-modules-arch vlc vlc-plugin-ffmpeg vulkan-radeon wireguard-tools yt-dlp yt-dlp-ejs
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
systemctl enable --now avahi-daemon.service libvirtd udisks2 ufw
usermod -aG libvirt kenneth
usermod -aG vboxusers kenneth

# Configure snapper
echo "Configuring snapper:"
if [ ! -f /etc/snapper/configs/root ]; then
snapper -c root create-config /
sed -i 's/TIMELINE_LIMIT_HOURLY="10"/TIMELINE_LIMIT_HOURLY="0"/g' /etc/snapper/configs/root
sed -i 's/TIMELINE_LIMIT_DAILY="10"/TIMELINE_LIMIT_DAILY="5"/g' /etc/snapper/configs/root
sed -i 's/TIMELINE_LIMIT_WEEKLY="0"/TIMELINE_LIMIT_WEEKLY="3"/g' /etc/snapper/configs/root
sed -i 's/TIMELINE_LIMIT_MONTHLY="10"/TIMELINE_LIMIT_MONTHLY="1"/g' /etc/snapper/configs/root
sed -i 's/TIMELINE_LIMIT_YEARLY="10"/TIMELINE_LIMIT_YEARLY="0"/g' /etc/snapper/configs/root
fi

# Configure reflector
echo "Configuring reflector:"
if [ -f /etc/xdg/reflector/reflector.conf ]; then
mv /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
fi
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country US" >> /etc/xdg/reflector/reflector.conf
echo "--latest 20" >> /etc/xdg/reflector/reflector.conf
echo "--number 10" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
systemctl enable --now reflector
systemctl enable --now reflector.timer

# Configure plymouth
echo "Configuring plymouth:"
if [ ! -f /boot/loader/entries/arch-nosplash.conf ]; then
cp /boot/loader/entries/arch.conf /boot/loader/entries/arch-nosplash.conf
sed -i 's/title Arch Linux/title Arch Linux (no splash screen)/g' /boot/loader/entries/arch-nosplash.conf
sed -i 's/@ rw/@ rw quiet splash/g' /boot/loader/entries/arch.conf
fi

# Configure firewall
echo "Configuring firewall:"
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

echo "Root portion complete!"
echo "Run the user portion to continue."
