#! /bin/bash

### Debian Server Setup Script for a Pre-Installed System ###
# Kenneth Simmons, 2024

echo "Debian Server Setup - Pre-Installed System - Kenneth Simmons, 2024"

# Set apt sources
echo "Setting apt sources:"
sed -i 's/main/main contrib non-free non-free-firmware/g' /etc/apt/sources.list

# Update the system
echo "Updating the system:"
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA ISO-8859-1/en_CA ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/g' /etc/locale.gen
sed -i 's/# en_US.ISO-8859-15 ISO-8859-15/en_US.ISO-8859-15 ISO-8859-15/g' /etc/locale.gen
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf
locale-gen

# Configure timezone
echo "Configuring timezone:"
timedatectl set-timezone America/New_York

# Set hostname
echo "Setting hostname:"
echo "Enter hostname:"
read hostname
hostnamectl set-hostname $hostname

# Create user account
echo "Creating user account:"
useradd -m -G sudo kenneth
passwd kenneth
usermod -s /bin/bash kenneth

# Install packages
echo "Installing packages:"
apt-get install -y ca-certificates curl exa gnupg htop neofetch snapd sudo systemd-timesyncd vim wget

# Install docker
echo "Installing docker:"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker kenneth

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt-get install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Setup monthly reboots
echo "Setting up monthly reboots:"
echo "0 4 1 * * root /sbin/reboot" >> /etc/crontab

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
echo "Next Steps:"
echo "- Configure SSH to require keys for login and listen on a different port"
echo "- Install 'linux-headers-amd64' and 'zfsutils-linux' for zfs support"
echo "- Install 'ufw' for firewall"
echo "- Reboot the server to finalize changes"
