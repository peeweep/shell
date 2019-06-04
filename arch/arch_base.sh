#!/usr/bin/bash
{
  echo "[archlinuxcn]" 
  echo "SigLevel = Optional TrustedOnly"
  echo "Server = http://mirrors.163.com/archlinuxcn/\$arch"
} | sudo tee -a /etc/pacman.conf
echo "[✔] Adding archlinuxcn mirrors"

sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.163.com/archlinux/\$repo/os/\$arch" >> sduo tee -a /etc/pacman.d/mirrorlist
echo "[✔] Adding the huaweicloud arch mirrors"

pacman -Syu archlinuxcn-keyring
echo "archlinuxcn-keyring installed"
#pacman -Syu haveged
#systemctl start haveged
#systemctl enable haveged
#rm -fr /etc/pacman.d/gnupg
#pacman-key --init
#pacman-key --populate archlinux
#pacman-key --populate archlinuxcn
#pacman -S --noconfirm archlinuxcn-keyring
#echo "[✔] Fix pacman archlinuxcn-keyring in gnupg-2.1"

sudo pacman -Syu axel chromium clang curl dnsutils fcitx fcitx-rime fcitx-configtool fcitx-im \
  flameshot gcc gdb git mpv nano noto-fonts-cjk openssh p7zip python-pip python2 python2-pip \
  shellcheck shfmt telegram-desktop ttf-opensans vim visual-studio-code-bin wget yay
echo "[✔] Installing base utils"

{
  echo "GTK_IM_MODULE=fcitx"
  echo "QT_IM_MODULE=fcitx"
  echo "XMODIFIERS=\"@im=fcitx\""
} | tee -a ~/.xprofile
echo "[✔] Add fcitx config to xprofile"
