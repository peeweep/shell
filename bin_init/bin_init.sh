#!/bin/bash

func() {
  sudo wget -N --no-check-certificate "${1}" -O /usr/bin/"${2}"
  sudo chmod +x /usr/bin/"${2}"
}

catbox="https://files.catbox.moe/ct8vm8"
func "${catbox}" "catbox"

gdrive="https://drive.google.com/uc?id=1iIjBty1FKxdGvyc4GATngwgbzQdPYz2p&export=download"
func "${gdrive}" "gdrive"

vimcn="https://img.vim-cn.com/4b/d623a900d9e3c1972d0ecd91e5e922c3336030.bat"
func "${vimcn}" "vimcn"

replace="https://img.vim-cn.com/01/def4ad0304a669b1d60c4c7f126bd32262233f.py"
func "${replace}" "replace"
