#!/usr/bin/bash

pacman_arch4edu() {
	{
		echo "[arch4edu]"
		echo "SigLevel = Never"
		echo "Server = https://mirrors.tuna.tsinghua.edu.cn/arch4edu/\$arch"
	} | sudo tee -a /etc/pacman.conf
	sudo pacman-key --recv-keys 7931B6D628C8D3BA | sudo pacman-key --lsign-key 7931B6D628C8D3BA
	echo "[✔]arch4edu installed"
}

pacman_archlinuxcn() {
	{
		echo "[archlinuxcn]"
		echo "SigLevel = Never"
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

pacman_aur() {
	yay -Syu clion clion-cmake clion-gdb clion-jre clion-lldb \
		fcitx5-chinese-addons-git fcitx5-git fcitx5-gtk-git \
		fcitx5-qt5-git kernel-modules-hook nerd-fonts-complete \
		systemtap visual-studio-code-bin
	echo "[✔] Installing aur packages"
}

pacman_base() {
	sudo pacman -Syu axel chromium clang cloc cmake curl dnsutils \
		flameshot gcc gdb git jq linux-headers lldb make mpv nano \
		net-tools noto-fonts-cjk npm openssh p7zip pacman-contrib \
		perf pkgfile python-pip python2 python2-pip shellcheck shfmt \
		telegram-desktop tldr translate-shell ttf-opensans unrar uptimed \
		valgrind vim wget yarn yay
	echo "[✔] Installing base utils"
}

pacman_chaotic-aur() {
	{
		echo "[chaotic-aur]"
		echo "SigLevel = Never"
		echo "Server = https://lonewolf.pedrohlc.com/\$repo/x86_64"
	} | sudo tee -a /etc/pacman.conf
	sudo pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
	sudo pacman-key --lsign-key 3056513887B78AEB
	echo "[✔]chaotic-aur installed"
}

pacman_disastrousaur() {
	{
		echo "[disastrousaur]"
		echo "SigLevel = Never"
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
	#pacman_arch4edu
	pacman_archlinuxcn
	# pacman_chaotic-aur
	# pacman_disastrousaur
	pacman_mirrorlist
	pacman_base
	pacman_aur
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
	fcitx5_x11
}

change_omz() {
	sudo pacman -S nerd-fonts-complete zsh zsh-autosuggestions
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

change_zshrc() {
	git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
	if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
		sed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
		mkdir -p ~/.zsh
		echo 'ZSH_THEME="powerlevel9k/powerlevel9k"
# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
' | tee ~/.zsh/powerlevel9k.zsh
		sed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
		sed -i '1ialias farsee="curl -F \"c=@-\" \"http://fars.ee/\""' ~/.zshrc
		sed -i "1iexport GPG_TTY=$(tty)" ~/.zshrc
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

desktop_session() {
	echo "$GDMSESSION" >>/tmp/GDMSESSION.txt
	if grep "plasma" GDMSESSION.txt; then
		konsole_scheme
	elif grep "xfce" GDMSESSION.txt; then
		xfceterminal_scheme
	fi
	rm /tmp/GDMSESSION.txt
	omz_init
	spacevim
}

pacman_init
#fcitx_init
fcitx5_init
desktop_session
