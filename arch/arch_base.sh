#!/usr/bin/bash

check_archlinuxcn() {
    word="[archlinuxcn]"
    file="/etc/pacman.conf"
    if [ -z "$(grep ${word} ${file})" ]; then
        echo "[archlinuxcn]" >>${file}
        echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >>${file}
        echo "[✔] Adding the tsinghua archlinucnx mirrors"
    else
        echo "archlinuxcn exist in ${file}"
    fi
}

check_mirrors() {
    word="Arch Linux repository mirrorlist"
    file="/etc/pacman.d/mirrorlist"
    if [ -z "$(grep ${word} ${file})" ]; then
        mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
        echo "Server = http://mirrors.huaweicloud.com/archlinux/\$repo/os/\$arch" >>/etc/pacman.d/mirrorlist
        echo "[✔] Adding the huaweicloud arch mirrors"
    else
        echo "mirrors has been updated"
    fi
}

check_cn_keyring() {
    package_name="archlinuxcn-keyring"
    package_search=$(sudo pacman -Q ${package_name})
    package_not_found="error: package '${package_name}' was not found"
    if [ "${package_not_found}" == "${package_search}" ]; then
        sudo pacman -Syu --noconfirm ${package_name}
    else
        echo "${package_name} has been installed"
    fi
}

check_base() {
    package_name="fcitx-rime"
    package_search=$(sudo pacman -Q ${package_name})
    package_not_found="error: package '${package_name}' was not found"
    if [ "${package_not_found}" == "${package_search}" ]; then
        sudo pacman -Syu --noconfirm axel clang curl chromium dnsutils \
            fcitx fcitx-rime fcitx-configtool fcitx-im git gcc mpv nano \
            noto-fonts-cjk openssh p7zip python-pip python2 python2-pip \
            visual-studio-code-bin vim wget yay
        echo "[✔] Installing base utils"
    else
        echo "base env has been installed"
    fi
}

check_fcitx() {
    word="GTK_IM_MODULE=fcitx"
    file="~/.xprofile"
    if [ -z "$(grep ${word} ${file})" ]; then
        echo "GTK_IM_MODULE=fcitx" >>${file}
        echo "QT_IM_MODULE=fcitx" >>${file}
        echo "XMODIFIERS=\"@im=fcitx\"" >>${file}
        echo "[✔] Add fcitx config to xprofile"
    else
        echo "fcitx has been setup"
    fi
}

# Get Permission
sudo pacman -Syyu

check_archlinuxcn
check_mirrors
check_cn_keyring
check_base
check_fcitx

# check_word() {
#     if [ -z "$(grep ${word} ${file})" ]; then
#         echo ${word} >>${file}
#     else
#         echo "${word} exist in ${file}"
#     fi
# }

# check_package() {
#     package_search=$(sudo pacman -Q ${package_name})
#     package_not_found="error: package '${package_name}' was not found"
#     if [ "${package_not_found}" == "${package_search}" ]; then
#         sudo pacman -Syu --noconfirm ${package_name}
#     else
#         echo "${package_name} has been installed"
#     fi
# }
