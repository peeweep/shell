#!/bin/bash

func() {
  sudo wget -N --no-check-certificate "${1}" -O /usr/bin/"${2}"
  sudo chmod +x /usr/bin/"${2}"
}

catbox="https://files.catbox.moe/ct8vm8"
func "${catbox}" "catbox"

vimcn="https://img.vim-cn.com/4b/d623a900d9e3c1972d0ecd91e5e922c3336030.bat"
func "${vimcn}" "vimcn"

replace="http://fars.ee/CA1-"
func "${replace}" "replace"

os=$(uname)
platform=$(uname -m)
gdrive_Linux_x86_64="https://drive.google.com/uc?id=1iIjBty1FKxdGvyc4GATngwgbzQdPYz2p&export=download"
gdrive_Darwin_x86_64="https://drive.google.com/uc?id=1GL18Ety5Le8IpNwRKO1iZg1YWV_cCWUN&export=download"
case "${os}" in
Linux)
  func "${gdrive_Linux_x86_64}" "gdrive"
  ;;
Darwin)
  func "${gdrive_Darwin_x86_64}" "gdrive"
  ;;
*)
  echo "Not Linux or MacOS, Plese download your platform and move it to /usr/bin"
  echo "https://drive.google.com/drive/folders/12GSQhLLdKDdKzq_a-7WOrip5HnFmm1v9"
  exit 1
  ;;
esac
exit 0
