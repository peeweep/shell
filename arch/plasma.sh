#!/usr/bin/bash

change_scheme() {
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
    sudo cp ~/Documents/iTerm2-Color-Schemes/konsole/*.colorscheme /usr/share/konsole
    rm -rf ~/Documents/iTerm2-Color-Schemes
    echo "You can change Konsole Color theme at 
Konsole -> Settings -> Edit Current Profile -> Appearance -> select color template ,
I recommand [Breeze]."
}

change_omz() {
    sudo pacman -S zsh zsh-autosuggestions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

change_zshrc() {
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
    sed -i "s/${before}/${after}/g" ~/.zshrc
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

change_scheme
omz_init
spacevim
