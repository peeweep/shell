#!/bin/bash
gdrive_linux_x64="https://drive.google.com/uc?id=1iIjBty1FKxdGvyc4GATngwgbzQdPYz2p&export=download"
sudo wget -N --no-check-certificate "${gdrive_linux_x64}" -O /usr/bin/gdrive 
sudo chmod +x /usr/bin/gdrive

