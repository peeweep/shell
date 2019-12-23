#!/usr/bin/env bash

pacman_archlinuxcn() {
  {
    echo "[archlinuxcn]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/\$arch"
    echo "Server = https://repo.archlinuxcn.org/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu archlinuxcn-keyring
  echo "[✔]archlinuxcn-keyring installed"
}

pacman_peeweep() {
  {
    echo "[peeweep]"
    echo "SigLevel = Never"
    echo "Server = https://peeweep.duckdns.org/archlinux/x86_64"
    echo "Server = https://peeweep.de/~pkg/archlinux/x86_64"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman -Syu curl
  curl https://peeweep.de/pubring.gpg | sudo pacman-key -a -
  sudo pacman-key --lsign-key A4A9C04411BE1F71
  sudo pacman -Syu
  echo "[✔]peeweep repo installed"
}

pacman_ck() {
  {
    echo "[repo-ck]"
    echo "SigLevel = Never"
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/repo-ck/\$arch"
    echo "Server = http://repo-ck.com/\$arch"
  } | sudo tee -a /etc/pacman.conf
  sudo pacman-key -r 5EE46C4C && sudo pacman-key --lsign-key 5EE46C4C
  sudo pacman -Syu
}

linux_ck() {
  march=$(gcc -c -Q -march=native --help=target -o /dev/null | grep march | awk '{print $2}' | head -n1)
  case "${march}" in
  bonnell)
    group="ck-atom"
    ;;
  silvermont)
    group="ck-silvermont"
    ;;
  core2)
    group="ck-core2"
    ;;
  nehalem)
    group="ck-nehalem"
    ;;
  sandybridge)
    group="ck-sandybridge"
    ;;
  ivybridge)
    group="ck-ivybridge"
    ;;
  haswell)
    group="ck-haswell"
    ;;
  broadwell)
    group="ck-broadwell"
    ;;
  skylake)
    group="ck-skylake"
    ;;
  pentium4 | prescott | nocona)
    group="ck-p4"
    ;;
  pentm | pentium-m)
    group="ck-pentm"
    ;;
  athlon | athlon-4 | athlon-tbird | athlon-mp | k8-sse3)
    group="ck-kx"
    ;;
  amdfam10)
    group="ck-k10"
    ;;
  btver1)
    group="ck-bobcat"
    ;;
  bdver1)
    group="ck-bulldozer"
    ;;
  bdver2)
    group="ck-piledriver"
    ;;
  znver1)
    group="ck-zen"
    ;;
  *)
    group="ck-generic"
    ;;
  esac

  sudo pacman -Syu ${group}
}

pacman_unofficial_packages() {
  # kernel-modules-hook
  sudo pacman -Syu kernel-modules-hook
  sudo systemctl enable linux-modules-cleanup
  sudo systemctl start linux-modules-cleanup

  # install kernel
  if [[ $(sudo dmidecode -s bios-vendor) == "Apple Inc." ]]; then
    sudo pacman -S linux-macbook linux-macbook-headers
    sudo pacman -S xorg-xrandr upower tlp-rdw broadcom-wl-dkms
    sudo systemctl enable macbook-wakeup.service
    sudo systemctl enable tlp.service tlp-sleep.service
    sudo sed -i 's/blacklist brcmfmac/\#blacklist brcmfmac/g' \
      /usr/lib/modprobe.d/broadcom-wl-dkms.conf
  else
    pacman_ck
    linux_ck
  fi

  # install unofficial packages
  sudo pacman -Syu fcitx5-chinese-addons-git fcitx5-gtk-git p7zip-zstd-codec \
    nerd-fonts-complete supersm visual-studio-code-bin unzip-iconv

  # install gpu driver
  gpu_model=$(lspci -mm | awk -F '\"|\" \"|\\(' '/"Display|"3D|"VGA/')
  if echo "${gpu_model}" | grep NVIDIA; then
    sudo pacman -S nvidia-dkms
  fi
  if echo "${gpu_model}" | grep Intel; then
    # I'm not clear intel device
    sudo pacman -S mesa xf86-video-intel
  fi

  sudo pacman -Rs nvidia
  sudo pacman -Rs linux
  sudo pacman -Rs linux-headers
  sudo pacman -Rs nvidia-lts
  sudo pacman -Rs linux-lts
  sudo pacman -Rs linux-lts-headers

  # rebuild grub
  sudo pacman -Syu grub efibootmgr
  sudo grub-install --target=x86_64-efi --efi-directory=/boot/ --bootloader-id=grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

pacman_official_packages() {
  sudo pacman -Syu alsa-utils autopep8 axel bind-tools chromium cloc cmake dmidecode \
    exfat-utils feh flameshot gdb htop jdk-openjdk jq jre-openjdk lldb man mpv ncdu \
    neofetch neovim net-tools noto-fonts-cjk noto-fonts-emoji noto-fonts-extra numlockx \
    p7zip pacman-contrib pavucontrol pkgfile pkgstats pulseaudio python-pylint screen \
    screenfetch shellcheck shfmt telegram-desktop tldr tmux tree ttf-opensans unrar \
    uptimed wget whois youtube-dl zstd

  # pkgfile
  sudo systemctl enable pkgfile-update.timer
  sudo systemctl start pkgfile-update.timer
  sudo pkgfile --update
}

pacman_haveged() {
  sudo pacman -Syu haveged
  sudo systemctl start haveged
  sudo systemctl enable haveged
}

pacman_mirrorlist() {
  sudo cp "${dotfiles}"/pacman/etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist
}

pacman_init() {
  pacman_haveged
  pacman_mirrorlist
  # add unofficial repo
  pacman_archlinuxcn
  pacman_peeweep
  # install packages
  pacman_official_packages
  pacman_unofficial_packages
}

fcitx5_init() {
  supersm fcitx5
}

omz_init() {
  sudo mkdir -p /usr/share/fonts/OTF/
  sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions oh-my-zsh-git zsh-theme-powerlevel9k
  sudo ln -s /usr/share/zsh-theme-powerlevel9k /usr/share/oh-my-zsh/themes/zsh-theme-powerlevel9k
  supersm zsh
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
  supersm xfce4-terminal
}

add_konsole_scheme() {
  sudo supersm konsole --target /
}

desktop_session() {
  case "${XDG_CURRENT_DESKTOP}" in
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

i3gaps() {
  sudo pacman -S i3-gaps i3status-rust-git xorg-xrdb
  supersm i3
  xfceterminal_scheme
}

dotfiles="$HOME/.dotfiles"
git clone https://github.com/peeweep/dotfiles "${dotfiles}"
cd "${dotfiles}" || exit
pacman_init
fcitx5_init
desktop_session
i3gaps

#### begin symlink update
# clang
supersm clang
# git
supersm git
# makepkg
sudo supersm makepkg --target /
# mutt
sudo pacman -S neomutt msmtp
supersm mutt
# pacman
sudo supersm pacman --target /
