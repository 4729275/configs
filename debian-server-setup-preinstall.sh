#! /bin/bash

### Debian Server Setup Script for a Pre-Installed System ###
# Kenneth Simmons, 2025

echo "Debian Server Setup - Pre-Installed System - Kenneth Simmons, 2025"

# Set apt sources
echo "Setting apt sources:"
if [ ! -f /etc/apt/sources.list.bak ]; then
cp /etc/apt/sources.list /etc/apt/sources.list.bak
sed -i 's/main/main contrib non-free non-free-firmware/g' /etc/apt/sources.list
fi

# Update the system
echo "Updating the system:"
apt-get update
apt-get dist-upgrade -y
apt-get autoremove -y

# Configure locales
echo "Configuring locales:"
sed -i 's/# en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
if [ -f /etc/locale.conf ]; then
mv /etc/locale.conf /etc/locale.conf.bak
fi
echo "LANG=en_CA.UTF-8" >> /etc/locale.conf
locale-gen

# Configure timezone
echo "Configuring timezone:"
timedatectl set-timezone America/New_York

# Set hostname
echo "Setting hostname:"
echo "Enter hostname:"
read hostname
hostnamectl hostname $hostname

# Create user account
echo "Creating user account:"
useradd -m -G sudo kenneth
passwd kenneth
usermod -s /bin/bash kenneth

# Install packages
echo "Installing packages:"
apt-get install -y ca-certificates curl exa ffmpeg gnupg htop snapd sudo systemd-timesyncd vim wget

# Install docker
echo "Installing docker:"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
if [ -f /etc/apt/sources.list.d/docker.sources ]; then
mv /etc/apt/sources.list.d/docker.sources /etc/apt/sources.list.d/docker.sources.bak
fi
echo "Types: deb" >> /etc/apt/sources.list.d/docker.sources
echo "URIs: https://download.docker.com/linux/debian" >> /etc/apt/sources.list.d/docker.sources
echo "Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")" >> /etc/apt/sources.list.d/docker.sources
echo "Components: stable" >> /etc/apt/sources.list.d/docker.sources
echo "Signed-By: /etc/apt/keyrings/docker.asc" >> /etc/apt/sources.list.d/docker.sources
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
usermod -aG docker kenneth

# Configure unattended-upgrades
echo "Configuring unattended-upgrades:"
apt-get install -y unattended-upgrades
systemctl enable --now unattended-upgrades

# Setup monthly reboots
echo "Setting up monthly reboots:"
if [ ! -f /etc/crontab.bak ]; then
cp /etc/crontab /etc/crontab.bak
echo "0 4 1 * * root /sbin/reboot" >> /etc/crontab
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
echo "- Configure SSH to require keys for login and listen on a different port"
echo "- Install 'linux-headers-amd64' and 'zfsutils-linux' for zfs support"
echo "- Install 'ufw' for firewall"
echo "- Reboot the server to finalize changes"
