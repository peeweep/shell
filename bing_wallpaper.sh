#!/bin/bash

sh_ver="0.0.1"
crontab_file="/usr/bin/crontab"
api_url="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN"
curPath=$(
  cd $(dirname "${BASH_SOURCE}")
  pwd
)
curFile=$(basename "${BASH_SOURCE}")

get_result() {
  pic_1080_url=$(curl -s "${api_url}" | grep -P "url.*?jpg&pid=hp" -o | awk -F '"' '{print $3}')
  result="bing.com${pic_1080_url}"
  current_url=$(curl -s "${api_url}" | grep -P "urlbase.*?copyright" -o | awk -F '"' '{print $3}')
  echo "[✓] current pic is http://bing.com${current_url}"
}

download_pic() {
  get_result
  curUser=$(who am i | awk '{print $1}')
  curDate=$(date +%Y%m%d)
  pic_folder="/home/${curUser}/Pictures/bing"
  pic_location="${pic_folder}/${curDate}".jpg
  mkdir -p "${pic_folder}"
  wget -q "${result}" -O "${pic_location}"
  echo "[✓] ${curDate}.jpg saved to ${pic_location}"
}

wallpaper_update() {
  download_pic
  gsettings set org.gnome.desktop.background picture-uri file://"${pic_location}"
  echo "[✓] set desktop background as ${pic_location}"
}

check_sys() {
  if [[ -f /etc/redhat-release ]]; then
    release="centos"
  elif grep -q "Arch Linux" /etc/issue; then
    release="arch"
  elif cat | grep -q "debian" /etc/issue; then
    release="debian"
  elif grep -q "ubuntu" /etc/issue; then
    release="ubuntu"
  elif grep -q -E "centos|red hat|redhat" /etc/issue; then
    release="centos"
  elif cat | grep -q "debian" /proc/version; then
    release="debian"
  elif grep -q "ubuntu" /proc/version; then
    release="ubuntu"
  elif grep -q -E "centos|red hat|redhat" /proc/version; then
    release="centos"
  fi
  #bit=`uname -m`
}

check_crontab_installed_status() {
  check_sys
  if [[ ! -e ${crontab_file} ]]; then
    echo -e "crontab not found, begin install..."
    if [[ ${release} == "centos" ]]; then
      sudo yum install crond -y
    elif [[ ${release== "arch"} ]]; then
      sudo pacman -S --noconfirm cronie
    else
      sudo apt-get install cron -y
    fi
    if [[ ! -e ${crontab_file} ]]; then
      echo -e "crontab install fail" && exit 1
    else
      echo -e "crontab install success"
    fi
  fi
}

crontab_add() {
  crontab -l | sudo tee "${curPath}/crontab.bak"
  sed -i "/${curFile} -u/d" "${curPath}/crontab.bak"
  echo -e "\n* */1 * * * /bin/bash ${curPath}/${curFile} update" >>"${curPath}/crontab.bak"
  crontab "${curPath}/crontab.bak"
  rm -r "${curPath}/crontab.bak"
  cron_config=$(crontab -l | grep "${curFile} update")
  if [[ -z ${cron_config} ]]; then
    echo -e "[×] crontab add fail!" && exit 1
  else
    echo -e "[✓] crontab add success!"
  fi
}

crontab_del() {
  crontab -l >"${curPath}/crontab.bak"
  sed -i "/${curFile} update/d" "${curPath}/crontab.bak"
  crontab "${curPath}/crontab.bak"
  rm -r "${curPath}/crontab.bak"
  cron_config=$(crontab -l | grep "${curFile} update")
  if [[ -n ${cron_config} ]]; then
    echo -e "[×] crontab remove fail!" && exit 1
  else
    echo -e "[✓] crontab remove success!"
  fi
}

help_document() {
  echo "
  bing wallpaper manager ${sh_ver}
    
    -h  --help        help document
    -u  --update      update wallpaper immediately
    -ca --cronadd     add cron task
    -cd --crondel     del cron task
    "
}

action=$1
if [[ "${action}" == "--update" ]]; then
  wallpaper_update
elif [[ "${action}" == "-u" ]]; then
  wallpaper_update
elif [[ "${action}" == "--cronadd" ]]; then
  crontab_add
elif [[ "${action}" == "-ca" ]]; then
  crontab_add
elif [[ "${action}" == "--crondel" ]]; then
  crontab_del
elif [[ "${action}" == "-cd" ]]; then
  crontab_del
else
  help_document
fi
