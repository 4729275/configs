#! /bin/bash

### Debian Server Setup Script ###
# Kenneth Simmons, 2023

echo "Debian Server Setup - Kenneth Simmons, 2023"

# Update the system
echo "Updating the system:"
apt update
apt dist-upgrade -y
apt autoremove -y

# Set hostname
echo "Setting hostname:"
read hostname
hostnamectl set-hostname $hostname

# Create user account
echo "Creating user account:"
useradd -m -g users -G sudo kenneth
passwd kenneth
usermod -s /bin/bash kenneth

# Install packages
echo "Installing packages:"
apt install -y vim neofetch exa htop sudo snap wget

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt install -y unattended-upgrades
vim /etc/apt/apt.conf.d/50unattended-upgrades
systemctl enable --now unattended-upgrades

# Set sudo privileges
echo "Setting sudo privileges:"
EDITOR=vim visudo

# Setup monthly reboots
echo "Setting up monthly reboots:"
echo "0 0 1 * * root /sbin/reboot" | tee -a /etc/crontab

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" | tee -a /home/kenneth/.bash_aliases
chown kenneth:users /home/kenneth/.bash_aliases

echo "Complete!"
echo "Reboot the server to finalize changes."
echo "Remember to set up SSH keys!"
