#!/bin/bash

homebrew_install() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew fetch --retry axel clang-format curl gcc git gnupg gnu-sed p7zip shellcheck shfmt wget
  brew install axel clang-format curl gcc git gnupg gnu-sed p7zip shellcheck shfmt wget
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
  brew fetch --retry zsh zsh-autosuggestions
  brew install zsh zsh-autosuggestions
  brew cleanup
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

homebrew_omz_setup() {
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
  if grep "ZSH_THEME=\"robbyrussell\"" ~/.zshrc; then
    gsed -i "s/ZSH_THEME=\"robbyrussell\"//" ~/.zshrc
    mkdir -p ~/.zsh
    cp conf/zsh/powerlevel9k.zsh ~/.zsh/powerlevel9k.zsh
    gsed -i '1isource ~/.zsh/powerlevel9k.zsh' ~/.zshrc
    cp conf/zsh/custom.zsh ~/.zsh/custom.zsh
    gsed -i '1isource ~/.zsh/custom.zsh' ~/.zshrc
    cp conf/zsh/export_path.zsh ~/.zsh/export_path.zsh
    gsed -i '1isource ~/.zsh/export_path.zsh' ~/.zshrc
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

gpg_server() {
  gpg_conf="$HOME/.gnupg/gpg.conf"
  if [ -f "${gpg_conf}" ]; then
    if grep "keyserver" -q "${gpg_conf}"; then
      grep "keyserver" "${gpg_conf}"
    else
      ehco "keyserver pgp.mit.edu" | tee -a "${gpg_conf}"
    fi
  else
    mkdir -p "$HOME/.gnupg"
    ehco "keyserver pgp.mit.edu" | tee -a "${gpg_conf}"
  fi
}

dotfiles() {
  cp conf/clang-format ~/.clang-format
  gpg_server
}

homebrew_install
iterm_scheme
homebrew_omz
spacevim
dotfiles
