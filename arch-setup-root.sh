#! /usr/bin/bash

### Arch Linux Setup Script, Root Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Setup, Root Portion - Kenneth Simmons, 2025"

# Install packages
echo "Installing packages:"
pacman -Sy --noconfirm audacity cdrdao cdrtools devede dnsmasq dvd+rw-tools eza fastfetch firefox fwupd gimp gvfs-dnssd handbrake hplip htop inetutils inkscape jre-openjdk k3b kid3 lib32-gcc-libs lib32-glibc libaacs libdvdcss libgpod libreoffice-fresh mkvtoolnix-gui musescore nextcloud-client obs-studio plymouth psensor qemu-full qt6-wayland reflector rhythmbox rpi-imager steam texlive-latex texstudio timeshift tk transmission-gtk ttf-liberation ttf-roboto udftools ufw v4l2loopback-dkms virt-manager virtualbox virtualbox-guest-iso virtualbox-host-modules-arch vlc vulkan-radeon wireguard-tools yt-dlp
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
systemctl enable --now avahi-daemon.service libvirtd udisks2 ufw
usermod -aG libvirt kenneth
usermod -aG vboxusers kenneth

# Configure reflector
echo "Configuring reflector:"
if [ -f /etc/xdg/reflector/reflector.conf ]; then
mv /etc/xdg/reflector/reflector.conf /etc/xdg/reflector/reflector.conf.bak
fi
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--country US" >> /etc/xdg/reflector/reflector.conf
echo "--latest 200" >> /etc/xdg/reflector/reflector.conf
echo "--number 20" >> /etc/xdg/reflector/reflector.conf
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

# Configure fwupd
echo "Configuring fwupd:"
systemctl start fwupd
sbctl sign -s -o /usr/lib/fwupd/efi/fwupdx64.efi.signed /usr/lib/fwupd/efi/fwupdx64.efi
if [ ! -f /etc/fwupd/fwupd.conf.bak ]; then
cp /etc/fwupd/fwupd.conf /etc/fwupd/fwupd.conf.bak
echo "[uefi_capsule]" >> /etc/fwupd/fwupd.conf
echo "DisableShimForSecureBoot=true" >> /etc/fwupd/fwupd.conf
systemctl restart fwupd
fi

# Configure yt-dlp
echo "Configuring yt-dlp:"
if [ -f /etc/yt-dlp.conf ]; then
mv /etc/yt-dlp.conf /etc/yt-dlp.conf.bak
fi
echo "-P /home/kenneth/Downloads/" >> /etc/yt-dlp.conf
echo "-x" >> /etc/yt-dlp.conf
echo "--audio-format best" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf

echo "Root portion complete!"
echo "Run the user portion to continue."
