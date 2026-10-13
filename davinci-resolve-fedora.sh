#! /usr/bin/bash

### DaVinci Resolve Install Script ###
# Kenneth Simmons, 2026

echo "DaVinci Resolve Install Script - Kenneth Simmons, 2026"

echo "The DaVinci Resplve archive should be downloaded to the current working directory."
echo "Enter the version of DaVinci Resolve downloaded and press Enter to begin the installation."
read DR_VERSION
unzip DaVinci_Resolve_${DR_VERSION}_Linux.zip
chomd +x DaVinci_Resolve_${DR_VERSION}_Linux/DaVinci_Resolve_${DR_VERSION}_Linux.run
SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_${DR_VERSION}_Linux/DaVinci_Resolve_${DR_VERSION}_Linux.run
if [ -d /opt/resolve/libs ]; then
sudo mkdir /opt/resolve/libs/disabled
sudo mv /opt/resolve/libs/libglib* /opt/resolve/libs/disabled/
sudo mv /opt/resolve/libs/libgio* /opt/resolve/libs/disabled/
sudo mv /opt/resolve/libs/libgmodule* /opt/resolve/libs/disabled/
sudo mv /opt/resolve/libs/libgobject* /opt/resolve/libs/disabled/
echo "Installation complete."
exit 0
fi
echo "Installation did not complete. Check console printout for errors."
exit 1
