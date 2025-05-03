#! /bin/bash

### Ubuntu Laptop Setup Script ###
# Kenneth Simmons, 2025

echo "Ubuntu Laptop Setup - Kenneth Simmons, 2025"

# Update the system
echo "Updating the system:"
apt-get update
apt-get full-upgrade -y
apt-get autoremove -y
snap refresh

# Install packages
echo "Installing packages:"
add-apt-repository ppa:ubuntuhandbook1/howdy -y
apt-get update
apt-get install audacity curl eza fastfetch ffmpeg fonts-roboto gimp gnome-calendar gnome-console gnome-snapshot gnome-tweaks gnome-weather handbrake howdy htop inkscape kid3 kleopatra libpam-python libreoffice mkvtoolnix-gui nextcloud-desktop obs-studio psensor python3-dlib python3-tk scdaemon strawberry systemd-zram-generator texstudio timeshift tlp tlp-rdw v4l-utils vim virt-manager vlc wireguard xournalpp yt-dlp -y
apt-get remove fonts-noto* -y
apt-get install fonts-noto-cjk fonts-noto-color-emoji -y
snap install zoom-client

# Configure swap-on-zram
echo "Configuring swap-on-zram:"
if [ -f /swap.img ]; then
swapoff /swap.img
rm /swap.img
cp /etc/fstab /etc/fstab.bak
sed -i 's/\/swap.img/#\/swap.img/g' /etc/fstab
fi
if [ -f /etc/systemd/zram-generator.conf ]; then
mv /etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf.bak
fi
echo "[zram0]" >> /etc/systemd/zram-generator.conf
echo "zram-size = min(ram, 8192)" >> /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" >> /etc/systemd/zram-generator.conf

# Configure grub
echo "Configuring grub:"
grub_lastline=$( tail -n 1 /etc/default/grub )
if [ $grub_lastline != GRUB_RECORDFAIL_TIMEOUT=0 ]; then
echo "GRUB_HIDDEN_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_RECORDFAIL_TIMEOUT=0" >> /etc/default/grub
sed -i 's/quick_boot="1"/quick_boot="0"/g' /etc/grub.d/30_os-prober
sed -i 's/set timeout=10/#set timeout=10/g' /etc/grub.d/30_os-prober
fi
update-grub

# Configure firewall
echo "Configuring firewall:"
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

# Configure howdy
echo "Configuring howdy:"
sed -i 's/device_path = none/device_path = \/dev\/video2/g' /etc/howdy/config.ini
sed -i 's/dark_theshold = 60/dark_threshold = 80/g' /etc/howdy/config.ini

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
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo snap refresh'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

# Remove packages:
echo "Removing packages:"
apt-get remove gnome-terminal -y
apt-get autoremove -y

echo "Complete!"
echo "Reboot the computer to finalize the changes."
