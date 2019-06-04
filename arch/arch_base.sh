#!/usr/bin/bash
echo "[archlinuxcn] " >>/etc/pacman.conf
echo "Server = https://mirrors.cqu.edu.cn/archlinuxcn/\$arch" >>/etc/pacman.conf
echo "[✔] Adding the tsinghua archlinuxcn mirrors"

mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.cqu.edu.cn/archlinux/\$repo/os/\$arch" >>/etc/pacman.d/mirrorlist
echo "[✔] Adding the huaweicloud arch mirrors"

pacman -Syu --noconfirm archlinuxcn-keyring
pacman -Syu --noconfirm haveged
systemctl start haveged
systemctl enable haveged
rm -fr /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate archlinuxcn
pacman -S --noconfirm archlinuxcn-keyring
echo "[✔] Fix pacman archlinuxcn-keyring in gnupg-2.1"

pacman -Syu --noconfirm axel chromium clang curl dnsutils \
  fcitx fcitx-rime fcitx-configtool fcitx-im \
  git gcc mpv noto-fonts-cjk nano openssh p7zip \
  python-pip python2 python2-pip visual-studio-code-bin vim wget yay
echo "[✔] Installing base utils"

{
  echo "GTK_IM_MODULE=fcitx"
  echo "QT_IM_MODULE=fcitx"
  echo "XMODIFIERS=\"@im=fcitx\""
} >>~/.xprofile
echo "[✔] Add fcitx config to xprofile"
