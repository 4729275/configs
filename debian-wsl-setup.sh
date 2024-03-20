#! /bin/bash

### Debian WSL Setup Script ###
# Kenneth Simmons, 2024

echo "Debian WSL Setup - Kenneth Simmons, 2024"

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

# Install packages
echo "Installing packages:"
apt-get install -y vim neofetch exa htop wget

# Create bash aliases
echo "Creating bash aliases:"
touch /home/kenneth/.bash_aliases
echo "alias ls='exa -al --group-directories-first'" >> /home/kenneth/.bash_aliases
echo "alias aptup='sudo apt update && sudo apt upgrade && sudo apt autoremove'" >> /home/kenneth/.bash_aliases
chown kenneth:kenneth /home/kenneth/.bash_aliases

echo "Complete!"
