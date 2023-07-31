#! /bin/bash

### Debian Server Setup Script for ARM ###
# Kenneth Simmons, 2023

echo "Debian Server Setup - ARM - Kenneth Simmons, 2023"

# Update the system
echo "Updating the system:"
apt update
apt dist-upgrade -y
apt autoremove -y

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA ISO-8859-1/en_CA ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_US.ISO-8859-15 ISO-8859-15/en_US.ISO-8859-15 ISO-8859-15/g' /etc/locale.gen
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
echo "LANG=en_CA.UTF-8" | tee -a /etc/locale.conf
locale-gen

# Set hostname
echo "Setting hostname:"
read hostname
hostnamectl set-hostname $hostname

# Create user account
echo "Creating user account:"
useradd -m -G sudo kenneth
passwd kenneth
usermod -s /bin/bash kenneth

# Install packages
echo "Installing packages:"
apt install -y exa htop neofetch snapd sudo ufw vim wget

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Setup monthly reboots
echo "Setting up monthly reboots:"
echo "0 0 1 * * root /sbin/reboot" | tee -a /etc/crontab

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" | tee -a /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
echo "Reboot the server to finalize changes."
echo "Remember to set up firewall and SSH keys!"
