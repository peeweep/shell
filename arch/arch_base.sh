#!/usr/bin/bash

pacman_arch4edu() {
	{
		echo "[arch4edu]"
		echo "SigLevel = Optional TrustedOnly"
		echo "Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/\$arch"
	} | sudo tee -a /etc/pacman.conf
	sudo pacman-key --recv-keys 7931B6D628C8D3BA | sudo pacman-key --lsign-key 7931B6D628C8D3BA
	echo "[✔]arch4edu installed"
}

pacman_archlinuxcn() {
	{
		echo "[archlinuxcn]"
		echo "SigLevel = Optional TrustedOnly"
		echo "Server = https://mirrors.sjtug.sjtu.edu.cn/archlinux-cn/\$arch"
	} | sudo tee -a /etc/pacman.conf
	sudo pacman -Syu archlinuxcn-keyring
	echo "[✔]archlinuxcn-keyring installed"
}
pacman_base() {
	sudo pacman -Syu axel chromium clang cloc curl dnsutils fcitx fcitx-rime fcitx-configtool fcitx-im \
		flameshot gcc gdb git mpv nano net-tools noto-fonts-cjk openssh p7zip python-pip python2 python2-pip \
		shellcheck shfmt telegram-desktop-bin ttf-opensans unrar vim visual-studio-code-bin wget yay
	echo "[✔] Installing base utils"
}

pacman_chaotic-aur() {
	{
		echo "#[chaotic-aur]"
		echo "#Server = https://lonewolf.pedrohlc.com/\$repo/x86_64"
		echo "#Server = http://aur.03.rw/chaotic-aur/\$repo/x86_64"
		echo "#Server = http://chaotic-aur.03.rw/\$repo/x86_64"
	} | sudo tee -a /etc/pacman.conf
	sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
	sudo pacman-key --lsign-key 3056513887B78AEB
	echo "[✔]chaotic-aur installed"
}

pacman_disastrousaur() {
	{
		echo "[disastrousaur]"
		echo "SigLevel = Optional TrustedOnly"
		echo "Server = https://mirror.repohost.de/\$repo/\$arch"
	} | sudo tee -a /etc/pacman.conf
	curl https://mirror.repohost.de/disastrousaur.key | sudo pacman-key -a -
	echo "[✔]disastrousaur installed"
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
	echo "Server = https://mirrors.huaweicloud.com/archlinux/\$repo/os/\$arch" | sudo tee -a /etc/pacman.d/mirrorlist
}

pacman_init() {
	pacman_arch4edu
	pacman_archlinuxcn
	pacman_disastrousaur
	pacman_mirrorlist
	pacman_base
}

fcitx_xprofile() {
	{
		echo "GTK_IM_MODULE=fcitx"
		echo "QT_IM_MODULE=fcitx"
		echo "XMODIFIERS=\"@im=fcitx\""
	} | tee -a ~/.xprofile
	echo "[✔] Add fcitx config to xprofile"
}

fcitx_telegram() {
	before='Exec=telegram-desktop -- %u'
	after='Exec=env QT_IM_MODULE=fcitx telegram-desktop -- %u'
	file='/usr/share/applications/telegramdesktop.desktop'
	sudo sed -i "s/${before}/${after}/g" ${file}
	echo "[✔] Add fcitx config to telegramdesktop.desktop"
}

fcitx_init() {
	fcitx_xprofile
	fcitx_telegram
}

pacman_init
fcitx_init
