```
sudo vim /etc/pacman.conf

[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch

sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo vim /etc/pacman.d/mirrorlist

Server = http://mirrors.huaweicloud.com/archlinux/$repo/os/$arch

sudo pacman -Syyu
sudo pacman -S archlinuxcn-keyring axel\
  clang curl dnsutils dolphin\
  fcitx fcitx-rime fcitx-configtool fcitx-googlepinyin fcitx-im\
  git gcc konsole mpv noto-fonts-cjk nano\
  openssh p7zip python-pip python2 python2-pip\
  visual-studio-code-bin vim wget yaourt
sudo yaourt -S google-chrome 

vim ~/.xprofile
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS="@im=fcitx"

# archlinuxcn-keyring issue:
# https://www.archlinuxcn.org/gnupg-2-1-and-the-pacman-keyring/
```