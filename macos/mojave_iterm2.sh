#!/bin/bash
echo "**************************************************"
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install wget curl axel git gcc vim 
brew cask install google-chrome iterm2 visual-studio-Code
git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
echo "You can import  Afterglow color template in Preferences - Profiles - Color Presets,
I recommand [Afterglow]."
brew tap caskroom/fonts
brew cask install font-sourcecodepro-nerd-font
echo "You can setting font in Preferences -> Profiles -> Text,
I recommand [Sauce Code Pro Nerd Font Complete]"

brew install zsh zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
before = 'ZSH_THEME="robbyrussell"'
after = '# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
'
sed -i "s/$before/$after/g" ~/.zshrc
pacman -S --noconfirm vim
curl -sLf https://spacevim.org/install.sh | bash
vim
