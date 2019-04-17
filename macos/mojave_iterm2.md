### For iterm2:
##### iTerm2-Color-Schemes:
```
git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
```
import  `Afterglow` color template in `Preferences` - `Profiles` - `Color Presets`
##### Nerd Fonts
```
brew tap caskroom/fonts
brew cask install font-sourcecodepro-nerd-font
```
setting `Sauce Code Pro Nerd Font Complete` font in `Preferences` - `Profiles` - `Text`



### For zsh:
##### OMZ:
```
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
brew install zsh-autosuggestions
```

##### powerlevel9k:
```
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

vim ~/.zshrc

# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE='nerdfont-complete'
```

### For vim:
##### spacevim:
```
brew install vim
curl -sLf https://spacevim.org/install.sh | bash
```
