echo "[archlinuxcn] " >> /etc/pacman.conf
echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch">>/etc/pacman.conf
echo "[✔] Adding the tsinghua archlinucn mirrors"

mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = http://mirrors.huaweicloud.com/archlinux/\$repo/os/\$arch" >>/etc/pacman.d/mirrorlist
echo "[✔] Adding the huaweicloud arch mirrors"

pacman -Syyu
pacman -S --noconfirm archlinuxcn-keyring 
pacman -Syu --noconfirm haveged
systemctl start haveged
systemctl enable haveged
rm -fr /etc/pacman.d/gnupg
pacman-key --init
pacman-key --populate archlinux
pacman-key --populate archlinuxcn
pacman -S --noconfirm archlinuxcn-keyring
echo "[✔] Fix pacman archlinuxcn-keyring in gnupg-2.1"

pacman -Syyu
pacman -S --noconfirm axel clang curl dnsutils \
  fcitx fcitx-rime fcitx-configtool fcitx-googlepinyin fcitx-im \
  git gcc mpv noto-fonts-cjk nano openssh p7zip \
  python-pip python2 python2-pip visual-studio-code-bin vim wget yay
echo "[✔] Installing base utils"

pacman -Syyu
pacman -S --noconfirm google-chrome
echo "[✔] Installing google-chrome"

echo "GTK_IM_MODULE=fcitx" >>~/.xprofile
echo "QT_IM_MODULE=fcitx" >>~/.xprofile
echo "XMODIFIERS=\"@im=fcitx\"" >>~/.xprofile
echo "[✔] Add fcitx config to xprofile"
