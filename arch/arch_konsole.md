### For Konsole:
##### iTerm2-Color-Schemes:
```
git clone https://github.com/mbadolato/iTerm2-Color-Schemes ~/Documents/iTerm2-Color-Schemes
sudo cp ~/Documents/iTerm2-Color-Schemes/konsole/*.colorscheme /usr/share/konsole
rm -rf ~/Documents/iTerm2-Color-Schemes
```
`Konsole` -> `Settings` -> `Edit Current Profile` -> `Appearance` -> select color template `Breeze`

##### Nerd Fonts
```
sudo pacman -S nerd-fonts-complete
```
`Konsole` -> `Settings` -> `Edit Current Profile` -> `Appearance` -> select font `Sauce Code Pro - Medium`



### For zsh:
##### OMZ:
```
sudo pacman -S zsh zsh-autosuggestions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /bin/zsh
```

##### powerlevel9k:
```
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
```
vim `~/.zshrc`
```
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Left
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir dir_writable vcs)
# Right
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status background_jobs history ram load time)
# for nerd-font
POWERLEVEL9K_MODE="nerdfont-complete"
```

### For vim:
##### spacevim:
```
sudo pacman -S vim
curl -sLf https://spacevim.org/install.sh | bash
```
