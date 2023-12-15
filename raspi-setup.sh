#! /bin/bash

### Raspbetty Pi Setup Script ###
# Kenneth Simmons, 2023

echo "Raspberry Pi Setup - Kenneth Simmons, 2023"

# Update the system
echo "Updating the system:"
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA ISO-8859-1/en_CA ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/# en_GB ISO-8859-1/en_GB ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_GB.ISO-8859-15 ISO-8859-15/en_GB.ISO-8859-15 ISO-8859-15/g' /etc/locale.gen
touch /etc/locale.conf
echo "LANG=en_CA.UTF-8" | tee -a /etc/locale.conf
locale-gen

# Install packages
echo "Installing packages:"
apt-get install -y exa neofetch vim

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt-get install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Setup monthly reboots
echo "Setting up monthly reboots:"
echo "0 3 1 * * root /sbin/reboot" | tee -a /etc/crontab

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" | tee -a /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
echo "Next Steps:"
echo "- Configure SSH to listen on a different port"
echo "- Reboot the server to finalize changes"
