#!/usr/bin/bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu archlinuxcn-keyring
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_peeweep() {
  {
    echo "[peeweep]"
    echo "SigLevel = Never"
    echo "Server = https://peeweep.duckdns.org/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu curl
  curl https://peeweep.de/pubring.gpg | sudo pacman-key -a -
  sudo pacman-key --lsign-key A4A9C04411BE1F71
  sudo pacman -Syu
  echo "[✔]peeweep repo installed"
}

pacman_aur() {
  sudo pacman -Syu fcitx5-chinese-addons-git fcitx5-gtk-git kernel-modules-hook yay-git \
    clion clion-cmake clion-gdb clion-jre clion-lldb visual-studio-code-bin \
    mpv-git nerd-fonts-complete youtube-dl-git \
    linux-lily linux-lily-headers nvidia-lily virtualbox-host-modules-lily vmware-workstation
  sudo pacman -Rs linux nvidia linux-lts nvidia-lts
  sudo systemctl enable pkgfile-update.timer  #pkgfile
  sudo systemctl enable linux-modules-cleanup # kernel-modules-hook
  sudo systemctl enable vmware-networks.service vmware-usbarbitrator.service vmware-hostd.service
  sudo modprobe -a vmw_vmci vmmon # vmware-workstation
}

pacman_base() {
  sudo pacman -Syu autopep8 axel bind-tools chromium cloc cmake exfat-utils feh \
    flameshot gdb htop jdk-openjdk jq jre-openjdk lldb man ncdu neofetch net-tools \
    noto-fonts-cjk noto-fonts-emoji noto-fonts-extra p7zip pacman-contrib pkgfile \
    pkgstats python-pylint screen screenfetch shellcheck shfmt telegram-desktop \
    thunderbird tldr tree ttf-opensans unrar uptimed virtualbox virtualbox-guest-iso wget
}

pacman_haveged() {
  sudo pacman -Syu haveged
  sudo systemctl start haveged
  sudo systemctl enable haveged
}

pacman_mirrorlist() {
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo cp conf/mirrorlist /etc/pacman.d/mirrorlist
}

pacman_init() {
  pacman_haveged
  pacman_mirrorlist
  pacman_archlinuxcn
  pacman_peeweep
  pacman_base
  pacman_aur
}

fcitx5_profile() {
  sudo killall -9 fcitx5
  mkdir -p ~/.config/fcitx5
  rm ~/.config/fcitx5/profile
  cp conf/fcitx5_profile ~/.config/fcitx5/profile
}

fcitx5_wayland() {
  {
    echo "GTK_IM_MODULE=fcitx5"
    echo "QT_IM_MODULE=fcitx5"
    echo "XMODIFIERS=\"@im=fcitx\""
  } | tee ~/.pam_environment
  echo "[✔] Add fcitx5 config to pam_environment"
}

fcitx5_x11() {
  {
    echo "export GTK_IM_MODULE=fcitx5"
    echo "export XMODIFIERS=@im=fcitx5"
    echo "export QT_IM_MODULE=fcitx5"
    echo "fcitx5 &"
  } | tee -a ~/.xprofile
  echo "[✔] Add fcitx5 config to xprofile"
}

fcitx5_init() {
  fcitx5_profile
  case "${XDG_SESSION_TYPE}" in
  x11)
    fcitx5_profile
    fcitx5_x11
    ;;
  wayland)
    fcitx5_profile
    fcitx5_wayland
    ;;
  esac
}

omz_init() {
  sudo mkdir -p /usr/share/fonts/OTF/
  sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions oh-my-zsh-git zsh-theme-powerlevel9k
  sudo ln -s /usr/share/zsh-theme-powerlevel9k /usr/share/oh-my-zsh/themes/zsh-theme-powerlevel9k
  cp /usr/share/oh-my-zsh/zshrc ~/.zshrc
  cd ~ || exit
  patch -p1 <"${script_path}"/zshrc.patch
  cd "${script_path}" || exit
}

spacevim() {
  sudo pacman -S vim
  curl -sLf https://spacevim.org/install.sh | bash
  vim
}

sound_panel() {
  sudo pacman -S pulseaudio xfce4-pulseaudio-plugin xfce4-panel pavucontrol
  echo "xfce4 volume panel installed"
}

xfceterminal_scheme() {
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
  mkdir -p ~/.local/share/xfce4/terminal
  cp -r ~/Documents/iTerm2-Color-Schemes/xfce4terminal/colorschemes ~/.local/share/xfce4/terminal/
  rm -rf ~/Documents/iTerm2-Color-Schemes
  echo "You can change xfce4-terminal Color theme at Edit >> Preferences >> Color >> Presets,
I recommand [Calamity] / [Builtin Tango Dark]."
}

download_iTerm2_scheme() {
  sudo wget https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/konsole/"$1".colorscheme -O /usr/share/konsole/"$1".colorscheme
}

add_konsole_scheme() {
  # git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
  # sudo cp ~/Documents/iTerm2-Color-Schemes/konsole/*.colorscheme /usr/share/konsole
  # rm -rf ~/Documents/iTerm2-Color-Schemes
  download_iTerm2_scheme Hivacruz
  download_iTerm2_scheme Dracula
}

desktop_session() {
  case "${XDG_SESSION_DESKTOP}" in
  KDE)
    add_konsole_scheme
    ;;
  XFCE)
    sound_panel
    xfceterminal_scheme
    ;;
  esac
  omz_init
  spacevim
}

script_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit
  pwd
)

pacman_init
fcitx5_init
desktop_session
cp conf/clang-format ~/.clang-format
