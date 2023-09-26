#! /bin/bash

### Arch Linux KDE Install Script ###
# Kenneth Simmons, 2023

echo "Arch Linux KDE Installer - Kenneth Simmons, 2023"

# Install packages
echo "Installing KDE packages:"
pacman -S --noconfirm ark audiocd-kio bluedevil breeze breeze-gtk breeze-plymouth colord-kde dolphin dolphin-plugins drkonqi elisa ffmpegthumbs flatpak-kcm gnome-themes-extra gwenview k3b kalk kate kclock kcron kde-gtk-config kdecoration kdegraphics-thumbnailers kdenetwork-filesharing kdepim-addons kdeplasma-addons kdialog kfind kgamma5 khotkeys kinfocenter kio-extras kio-gdrive kio-zeroconf kjournald kleopatra kmenuedit kmix koko konsole kpipewire kscreen kscreenlocker ksystemlog ksystemstats kwallet-pam kwalletmanager kwayland-integration kweather kwin kwrited layer-shell-qt libkscreen libksysguard merkuro milou okular partitionmanager phonon-qt5-vlc pipewire-jack plasma-desktop plasma-disks plasma-firewall plasma-integration plasma-nm plasma-pa plasma-systemmonitor plasma-thunderbolt plasma-wayland-session plasma-workspace plasma-workspace-wallpapers plymouth-kcm polkit-kde-agent powerdevil print-manager pulseaudio-alsa sddm sddm-kcm signon-kwallet-extension spectacle systemsettings ttf-liberation ufw wireplumber xdg-desktop-portal xdg-desktop-portal-kde
echo "Installing other packages:"
pacman -S firefox thunderbird

# Enable gdm:
echo "Enabling sddm:"
systemctl enable sddm

echo "Done!"
echo "Reboot to enter KDE."
