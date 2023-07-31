#! /bin/bash

### Debian Server Setup Script for a Pre-Installed System ###
# Kenneth Simmons, 2023

echo "Debian Server Setup - Pre-Installed System - Kenneth Simmons, 2023"

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
useradd -m -G sudo kenneth
passwd kenneth
usermod -s /bin/bash kenneth

# Install packages
echo "Installing packages:"
apt install -y ca-certificates curl exa gnupg htop neofetch snapd sudo ufw vim wget

# Install docker
echo "Installing docker:"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker kenneth

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
