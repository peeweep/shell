#!/bin/bash
gdrive_linux_x64='http://docs.google.com/uc?id=1Ej8VgsW5RgK66Btb9p74tSdHMH3p4UNb&export=download'
sudo wget -N --no-check-certificate "${gdrive_linux_x64}" -O /usr/bin/gdrive 
sudo chmod +x /usr/bin/gdrive

