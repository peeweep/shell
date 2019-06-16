#!/usr/bin/bash

sudo pacman -S pulseaudio xfce4-pulseaudio-plugin xfce4-panel pavucontrol
echo "xfce4 volume panel installed"

git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
mkdir -p ~/.local/share/xfce4/terminal
cp -r ~/Documents/iTerm2-Color-Schemes/xfce4terminal/colorschemes ~/.local/share/xfce4/terminal/
rm -rf ~/Documents/iTerm2-Color-Schemes
echo "You can change xfce4-terminal Color theme at Edit >> Preferences >> Color >> Presets,
I recommand [Calamity] / [Builtin Tango Dark]."

sudo pacman -S nerd-fonts-complete
echo "You can change xfce4-terminal font at Edit >> Preferences >> Appearance,
I recommand [SauceCodePro Nerd Font Mono Medium]."

sudo pacman -S zsh zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" --unattended
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
before='ZSH_THEME="robbyrussell"'
after='alias farsee="curl -F \"c=@-\" \"http://fars.ee/\""
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"
source /usr/share/doc/pkgfile/command-not-found.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
'
sed -i "s/$before/$after/g" ~/.zshrc

sudo pacman -S vim
curl -sLf https://spacevim.org/install.sh | bash
vim
