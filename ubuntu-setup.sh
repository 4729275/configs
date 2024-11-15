#! /bin/bash

### Ubuntu Laptop Setup Script ###
# Kenneth Simmons, 2024

echo "Ubuntu Laptop Setup - Kenneth Simmons, 2024"

# Update the system
echo "Updating the system:"
apt-get update
apt-get upgrade -y
apt-get autoremove -y
snap refresh

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
sed -i 's/LANG=en_US.UTF-8/LANG=en_CA.UTF-8/g' /etc/locale.conf

# Install packages
echo "Installing packages:"
add-apt-repository ppa:slimbook/slimbook -y
apt-get install audacity curl eza fonts-roboto gimp gnome-calendar gnome-console gnome-snapshot gnome-tweaks gnome-weather handbrake htop inkscape kleopatra libreoffice nextcloud-desktop psensor rhythmbox scdaemon slimbookface systemd-zram-generator texstudio tilem timeshift tlp tlp-rdw vim virt-manager vlc wireguard xournalpp zint-qt -y
apt-get remove fonts-noto* -y
apt-get install fonts-noto-cjk fonts-noto-color-emoji -y
snap install zoom-client

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && sudo snap refresh'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

# Configure swap-on-zram
echo "Configuring swap-on-zram:"
swapoff /swap.img
rm /swap.img
cp /etc/fstab /etc/fstab.bak
sed -i '$d' /etc/fstab
if [ -f /etc/systemd/zram-generator.conf ]; then
mv /etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf.bak
fi
touch /etc/systemd/zram-generator.conf
echo "[zram0]" >> /etc/systemd/zram-generator.conf
echo "zram-size = min(ram, 8192)" >> /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" >> /etc/systemd/zram-generator.conf


# Configure systemd timeouts
echo "Configuring systemd timeouts:"
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=15s/g' /etc/systemd/system.conf
sed -i 's/#DefaultDeviceTimeoutSec=90s/DefaultDeviceTimeoutSec=15s/g' /etc/systemd/system.conf

# Configure grub
echo "Configuring grub:"
echo "GRUB_HIDDEN_TIMEOUT=0" >> /etc/default/grub
echo "GRUB_RECORDFAIL_TIMEOUT=0" >> /etc/default/grub
sed -i 's/OS_PROBER=true/OS_PROBER=false/g' /etc/default/grub
sed -i 's/quick_boot="1"/quick_boot="0"/g' /etc/grub.d/30_os-prober
sed -i 's/set timeout=10/#set timeout=10/g' /etc/grub.d/30_os-prober
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
sed -i 's/dark_threshold = 60/dark_threshold = 85/g' /etc/howdy/config.ini

# Remove packages:
echo "Removing packages:"
apt-get remove gnome-terminal -y
apt-get autoremove -y

echo "Complete!"
echo "Reboot the computer to finalize the changes."
