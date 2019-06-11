#!/bin/bash
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install axel clang-format curl gcc git gnupg p7zip shellcheck shfmt vim wget
brew cask install chromium iina iterm2 squirrel visual-studio-Code telegram-desktop

git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
echo "You can import  Afterglow color template in Preferences - Profiles - Color Presets,
I recommand [Afterglow]."

brew tap caskroom/fonts
brew cask install font-sourcecodepro-nerd-font
echo "You can setting font in Preferences -> Profiles -> Text,
I recommand [Sauce Code Pro Nerd Font Complete]"

brew install zsh zsh-autosuggestions
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
source  /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
'
sed -i "s/$before/$after/g" ~/.zshrc

curl -sLf https://spacevim.org/install.sh | bash
vim
