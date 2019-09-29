#!/usr/bin/bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu archlinuxcn-keyring | tee cnkeyring.log
  if grep -q "could not be locally signed." cnkeyring.log; then
    pacman_haveged
    rm cnkeyring.log
  else
    echo "no error"
    rm cnkeyring.log
  fi
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_chaotic() {
  {
    echo "[chaotic-aur]"
    echo "SigLevel = Never"
    echo "Server = http://lonewolf-builder.duckdns.org/chaotic-aur/x86_64"
    echo "Server = http://chaotic.bangl.de/chaotic-aur/x86_64"
  } | sudo tee -a /etc/pacman.conf
  echo "[✔]chaotic-aur installed"
}

pacman_fermiarcs() {
  {
    echo "[fermiarcs]"
    echo "Server = https://pkg.fermiarcs.com/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman-key --recv-keys A4A9C04411BE1F71
  sudo pacman-key --lsign-key A4A9C04411BE1F71
  echo "[✔]fermiarcs repo installed"
}

pacman_aur() {
  aur_fcitx5="fcitx5-chinese-addons-git fcitx5-gtk-git"
  aur_browser="brave-bin firefox-nightly-en-us google-chrome"
  aur_arch="kernel-modules-hook yay-git"
  aur_fonts="nerd-fonts-complete"
  aur_editor="visual-studio-code-bin"
  aur_media="mpv-git youtube-dl-git"
  sudo pacman -Syu "${aur_fcitx5}" "${aur_browser}" "${aur_arch}" \
    "${aur_fonts}" "${aur_editor}" "${aur_media}"
}

pacman_base() {
  base_net_utils="axel bind-tools net-tools wget"
  base_level_1="p7zip unrar htop neofetch screen shellcheck"
  base_level_2="cloc exfat-utils jq ncdu tree uptimed shfmt tldr"
  base_arch="pacman-contrib pkgfile pkgstats"
  base_gui="feh flameshot okular telegram-desktop thunderbird"
  base_python_packages="autopep8 python-pylint"
  base_build_env="cmake gdb jdk-openjdk jre-openjdk lldb"
  base_fonts="noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-opensans"
  sudo pacman -Syu "${base_net_utils}" "${base_level_1}" "${base_level_2}" \
    "${base_arch}" "${base_gui}" "${base_python_packages}" "${base_build_env}" \
    "${base_fonts}"
}

pacman_haveged() {
  sudo pacman -Syu haveged
  sudo systemctl start haveged
  sudo systemctl enable haveged
  sudo rm -fr /etc/pacman.d/gnupg
  sudo pacman-key --init
  sudo pacman-key --populate archlinux
  sudo pacman-key --populate archlinuxcn
  sudo pacman -S --noconfirm archlinuxcn-keyring
  echo "[✔] Fix pacman archlinuxcn-keyring in gnupg-2.1"
}

pacman_mirrorlist() {
  sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
  sudo reflector --verbose --country CHINA -l 200 -p https --sort rate --save /etc/pacman.d/mirrorlist
  # echo "Server = https://mirrors.neusoft.edu.cn/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
}

pacman_init() {
  mkdir -p ~/.gnupg
  echo "keyserver hkps://gpg.mozilla.org" | tee -a ~/.gnupg/gpg.conf
  echo "keyserver hkps://gpg.mozilla.org" | sudo tee -a /etc/pacman.d/gnupg/gpg.conf
  pacman_archlinuxcn
  pacman_chaotic
  pacman_fermiarcs
  pacman_mirrorlist
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

change_omz() {
  sudo mkdir -p /usr/share/fonts/OTF/
  sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

change_zshrc() {
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
    sed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
    mkdir -p ~/.zsh
    cp conf/zsh/powerlevel9k.zsh ~/.zsh/powerlevel9k.zsh
    sed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
    cp conf/zsh/custom.zsh ~/.zsh/custom.zsh
    sed -i '1isource ~/.zsh/custom.zsh' ~/.zshrc
  else
    echo "not found"
  fi
}

omz_init() {
  change_omz
  change_zshrc
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

konsole_scheme() {
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
  sudo cp ~/Documents/iTerm2-Color-Schemes/konsole/*.colorscheme /usr/share/konsole
  rm -rf ~/Documents/iTerm2-Color-Schemes
  echo "You can change Konsole Color theme at 
Konsole -> Settings -> Edit Current Profile -> Appearance -> select color template ,
I recommand [Breeze]."
}

kernel_lts() {
  case $(yay -Q nvidia | awk '{print $1}') in
  nvidia)
    sudo pacman -Rs nvidia
    sudo pacman -S linux-lts linux-lts-headers nvidia-lts
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    ;;
  *)
    case $(yay -Q linux | awk '{print $1}') in
    linux)
      sudo pacman -Rs linux
      sudo pacman -S linux-lts linux-lts-headers nvidia-lts
      sudo grub-mkconfig -o /boot/grub/grub.cfg
      ;;
    esac
    ;;
  esac
}

desktop_session() {
  case "${XDG_SESSION_DESKTOP}" in
  KDE)
    konsole_scheme
    ;;
  XFCE)
    sound_panel
    xfceterminal_scheme
    ;;
  esac
  omz_init
  spacevim
}



dotfiles() {
  cp conf/clang-format ~/.clang-format
  # Updade /etc/makepkg.conf
  cd /etc || exit
  sudo patch -p1 <"${script_path}"/conf/makepkg.patch
  cd "${script_path}" || exit
}

script_path=$(
  cd "$(dirname "${BASH_SOURCE[0]}")" || exit
  pwd
)

pacman_init
fcitx5_init
desktop_session
dotfiles
kernel_lts
