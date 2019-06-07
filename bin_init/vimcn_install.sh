#!/bin/bash
echo "curl -F \"name=@$1\" https://img.vim-cn.com/" | sudo tee /usr/bin/vimcn
sudo chmod +x /usr/bin/vimcn

