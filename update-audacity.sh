#! /usr/bin/bash

### Audacity AppImage Updater ###
# Kenneth Simmons, 2026

echo "Audacity AppImage Updater - Kenneth Simmons, 2026"

# Move new AppImage file to /opt
echo "Moving new AppImage file to /opt:"
sudo cp /home/kenneth/Downloads/audacity*.AppImage /opt/Audacity4.AppImage
rm /home/kenneth/Downloads/audacity*.AppImage

echo "Complete!"
