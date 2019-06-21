#!/bin/bash

get_result() {
  pic_1080_url=$(curl -s "${api_url}" | grep -P "url.*?jpg&pid=hp" -o | awk -F '"' '{print $3}')
  result="bing.com${pic_1080_url}"
  current_url=$(curl -s "${api_url}" | grep -P "urlbase.*?copyright" -o | awk -F '"' '{print $3}')
  echo "[✓] current pic is http://bing.com${current_url}"

}

download_pic() {
  get_result
  curDate=$(date +%Y%m%d)
  pic_location="/home/lusty01/Pictures/bing/""${curDate}".jpg
  wget -q "${result}" -O "${pic_location}"
  echo "[✓] ${curDate}.jpg saved to ${pic_location}"
}

set_wallpaper() {
  download_pic
  gsettings set org.gnome.desktop.background picture-uri file://${pic_location}
  echo "[✓] set desktop background as ${pic_location}"
}

api_url="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN"
set_wallpaper
