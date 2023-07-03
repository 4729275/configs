#! /bin/bash

### Debian Laptop Setup Script ###
# Kenneth Simmons, 2023

echo "Debian Laptop Setup - Kenneth Simmons, 2023"

# Configure APT
echo "Configuring APT:"
sed -i '1,2d' /etc/apt/sources.list
sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

# Update the system
echo "Updating the system:"
apt update -y && apt full-upgrade -y && apt autoremove -y

# Install packages
echo "Installing packages:"
apt install -y audacity dbus-x11 exa flatpak fonts-roboto gimp git gnome-software-plugin-flatpak htop neofetch nextcloud-desktop psensor thunderbird tilem timeshift ttf-mscorefonts-installer vim vlc wireguard-tools
apt remove -y firefox-esr libreoffice*
apt autoremove -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub com.github.GradienceTeam.Gradience
flatpak install -y flathub org.kde.kleopatra
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.onlyoffice.desktopeditors
flatpak install -y flathub us.zoom.Zoom
cd /usr/share/themes
wget https://github.com/lassekongo83/adw-gtk3/releases/download/v4.8/adw-gtk3v4-8.tar.xz
tar -xf adw-gtk3v4-8.tar.xz
rm adw-gtk3v4-8.tar.xz
cd

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down kenneth-home'" | tee -a /home/kenneth/.bash_aliases
echo "alias khome='ssh -i \$HOME/.ssh/kenneth-home -p 314 kenneth@192.168.1.20'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && flatpak update'" | tee -a /home/kenneth/.bash_aliases

# Fix display issues
echo "Fixing display issues:"
if [ -f /etc/modprobe.d/i915.conf ]; then
	rm /etc/modprobe.d/i915.conf
fi
touch /etc/modprobe.d/i915.conf
echo "options i915 enable_psr=0" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_guc=3" | tee -a /etc/modprobe.d/i915.conf
echo "options i915 enable_fbc=1" | tee -a /etc/modprobe.d/i915.conf
update-initramfs -u

# Enable fractional scaling
echo "Enabling fractional scaling:"
su kenneth
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

echo "Complete!"
echo "Reboot the computer to finalize the changes."
