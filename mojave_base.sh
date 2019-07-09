#!/bin/bash

homebrew_install() {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew fetch --retry axel clang-format curl gcc git gnupg gsed p7zip shellcheck shfmt wget
    brew install axel clang-format curl gcc git gnupg gsed p7zip shellcheck shfmt wget
    brew cask install google-chrome iina iterm2 visual-studio-Code telegram
}

iterm_scheme() {
    git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
    echo "You can import  Afterglow color template in Preferences - Profiles - Color Presets,
I recommand [Afterglow]."
}

homebrew_nerd() {
    brew tap caskroom/fonts
    brew cask install font-sourcecodepro-nerd-font
    echo "You can setting font in Preferences -> Profiles -> Text,
I recommand [Sauce Code Pro Nerd Font Complete]"
}

homebrew_omz_install() {
    brew install zsh zsh-autosuggestions
    brew cleanup
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

homebrew_omz_setup() {
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
    if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
        gsed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
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
        gsed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
        gsed -i '1ialias farsee="curl -F \"c=@-\" \"http://fars.ee/\""' ~/.zshrc
        gsed -i '1iexport GPG_TTY=$(tty)' ~/.zshrc
    else
        echo "not found"
    fi
}

homebrew_omz() {
    homebrew_nerd
    homebrew_omz_install
    homebrew_omz_setup
}

spacevim() {
    brew fetch --retry vim
    brew install vim
    curl -sLf https://spacevim.org/install.sh | bash
    vim
}

homebrew_install
iterm_scheme
homebrew_omz
spacevim
