#! /usr/bin/bash

### Arch Linux Laptop Setup Script, Root Portion ###
# Kenneth Simmons, 2025

echo "Arch Linux Laptop Setup, Root Portion - Kenneth Simmons, 2025"

# Install packages
echo "Installing packages:"
pacman -Sy --noconfirm audacity eza fastfetch firefox fwupd gimp gvfs-dnssd handbrake hplip htop inkscape kid3 libreoffice-still mkvtoolnix-gui nextcloud-client obs-studio plymouth psensor qemu-full qt6-wayland reflector rhythmbox texlive-latex texstudio timeshift tk tlp tlp-rdw ttf-liberation ttf-roboto ufw v4l2loopback-dkms virt-manager vlc wireguard-tools xournalpp yt-dlp
sed -i 's/#firewall_backend = "nftables"/firewall_backend = "iptables"/g' /etc/libvirt/network.conf
systemctl enable --now avahi-daemon.service libvirtd tlp ufw
usermod -aG libvirt kenneth

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

# Configure tlp
echo "Configuring tlp:"
systemctl mask systemd-rfkill.service systemd-rfkill.socket
sed -i 's/#USB_AUTOSUSPEND=1/USB_AUTOSUSPEND=0/g' /etc/tlp.conf
systemctl restart tlp
tlp start

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
