#! /bin/bash

### Raspbetty Pi Setup Script ###
# Kenneth Simmons, 2025

echo "Raspberry Pi Setup - Kenneth Simmons, 2025"

# Update the system
echo "Updating the system:"
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# Configure sudo
echo "Configuring sudo:"
if [ -f /etc/sudoers.d/010_pi-nopasswd ]; then
rm /etc/sudoers.d/010_pi-nopasswd
fi

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
if [ -f /etc/locale.conf ]; then
mv /etc/locale.conf /etc/locale.conf.bak
fi
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf
locale-gen

# Install packages
echo "Installing packages:"
apt-get install -y eza vim

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt-get install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Setup monthly reboots
echo "Setting up monthly reboots:"
if [ ! -f /etc/crontab.bak ]; then
cp /etc/crontab /etc/crontab.bak
echo "0 3 1 * * root /sbin/reboot" >> /etc/crontab
fi

# Create bash aliases
echo "Creating bash aliases:"
if [ -f /home/kenneth/.bash_aliases ]; then
mv /home/kenneth/.bash_aliases /home/kenneth/.bash_aliases.bak
chown kenneth:kenneth /home/kenneth/.bash_aliases.bak
fi
echo "alias ls='exa -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
echo "Next Steps:"
echo "- Configure SSH to listen on a different port"
echo "- Reboot the server to finalize changes"
