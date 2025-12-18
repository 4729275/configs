#! /usr/bin/bash

### Debian Stable Laptop Setup Script ###
# Kenneth Simmons, 2025

echo "Debian Stable Laptop Setup - Kenneth Simmons, 2025"

# Update the system
echo "Updating the system:"
apt-get update
apt-get full-upgrade -y

# Install packages
echo "Installing packages:"
apt-get install eza fastfetch flatpak fonts-noto-cjk fonts-roboto gnome-software-plugin-flatpak gnome-themes-extra htop plymouth-themes psensor ptyxis python3-tk rhythmbox systemd-zram-generator texstudio timeshift tlp tlp-rdw ufw v4l2loopback-dkms vim virt-manager wireguard yt-dlp -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub org.audacityteam.Audacity com.github.tchx84.Flatseal org.gimp.GIMP com.google.EarthPro fr.handbrake.ghb org.inkscape.Inkscape org.kde.kid3 org.bunkus.mkvtoolnix-gui com.nextcloud.desktopclient.nextcloud com.obsproject.Studio org.onlyoffice.desktopeditors org.kde.PlatformTheme.QGnomePlatform/x86_64/6.6 org.kde.WaylandDecoration.QGnomePlatform-decoration/x86_64/6.5 org.videolan.VLC com.github.xournalpp.xournalpp -y
flatpak override --env=QT_DEVICE_PIXEL_RATIO=2 com.google.EarthPro
git clone https://gitlab.gnome.org/GNOME/adwaita-fonts /home/kenneth/adwaita-fonts
mkdir /home/kenneth/.local/share/fonts
cp /home/kenneth/adwaita-fonts/mono/*.ttf /home/kenneth/.local/share/fonts/
cp /home/kenneth/adwaita-fonts/sans/*.ttf /home/kenneth/.local/share/fonts/
rm -rf /home/kenneth/adwaita-fonts/
chown -R kenneth:kenneth /home/kenneth/.local/share/fonts/
systemctl start ufw tlp
usermod -aG libvirt kenneth

# Configure firewall
echo "Configuring firewall:"
ufw default allow outgoing
ufw default deny incoming
ufw enable

# Configure swap-on-zram:
echo "Configuring swap-on-zram:"
if [ -f /etc/systemd/zram-generator.conf ]; then
mv /etc/systemd/zram-generator.conf /etc/systemd/zram-generator.conf.bak
fi
echo "[zram0]" >> /etc/systemd/zram-generator.conf
echo "zram-size = min(ram, 8192)" >> /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" >> /etc/systemd/zram-generator.conf

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
echo "--audio-format opus" >> /etc/yt-dlp.conf
echo "-o \"%(title)s.%(ext)s\"" >> /etc/yt-dlp.conf
echo "--cookies-from-browser firefox" >> /etc/yt-dlp.conf
echo "--remote-components ejs:github" >> /etc/yt-dlp.conf

# Create bash aliases
echo "Creating bash aliases:"
if [ ! -f /home/kenneth/.bash_aliases ]; then
echo "alias ls='eza -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove && flatpak update'" >> /home/kenneth/.bash_aliases
echo "alias wgup='sudo wg-quick up home'" >> /home/kenneth/.bash_aliases
echo "alias wgdn='sudo wg-quick down home'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases
fi

# Remove packages
echo "Removing packages:"
apt-get purge gnome-music gnome-terminal -y
apt-get autoremove -y

echo "Complete!"
echo "Reboot the computer to finalize the changes."
