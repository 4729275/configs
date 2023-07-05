#! /bin/bash

### Debian WSL Setup Script ###
# Kenneth Simmons, 2023

echo "Debian WSL Setup - Kenneth Simmons, 2023"

# Update the system
echo "Updating the system:"
apt update
apt dist-upgrade -y
apt autoremove -y

# Set hostname
echo "Setting hostname:"
read hostname
hostnamectl set-hostname $hostname

# Install packages
echo "Installing packages:"
apt install -y vim neofetch exa htop sudo snap wget

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first --color=always'" | tee -a /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" | tee -a /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
