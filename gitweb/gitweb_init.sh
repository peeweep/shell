#!/bin/bash

nginx_file() {
  nginx_file="/etc/nginx/conf.d/gitweb.conf"
  example="example.com"
  sudo wget http://fars.ee/HJ9e -O ${nginx_file}
  echo "enter your server_name for nginx config file, default: example.com"
  read -r server_name
  [[ -z "${server_name}" ]] && server_name="example.com"
  sudo sed -i "s/${example}/${server_name}/g" ${nginx_file}
}

gitweb_file() {
  default_projectroot='/var/lib/git'
  gitweb_file="/etc/gitweb.conf"
  echo "enter your giweb projectroot, default: /gitweb"
  read -r projectroot
  [[ -z "${projectroot}" ]] && projectroot='/gitweb'
  sudo mkdir -p ${projectroot}
  sudo sed -i "s|${default_projectroot}|${projectroot}|" ${gitweb_file}
  curl https://fars.ee/4rR9 | sudo tee -a ${gitweb_file}
}

git_description() {
  echo "enter your default description for all projects, default: no description"
  read -r description
  [[ -z "${description}" ]] && description='no description'
  description_file="/usr/share/git-core/templates/description"
  sudo rm ${description_file}
  echo "${description}" | sudo tee ${description_file}
}

gitweb_theme() {
  repository="https://github.com/kogakure/gitweb-theme.git"
  gitweb_folder="/usr/share/gitweb"
  sudo git clone ${repository} ${gitweb_folder}/gitweb_theme
  file=(git-favicon.png git-logo.png gitweb.css)
  for i in "${!file[@]}"; do
    sudo mv "${gitweb_folder}"/static/"${file[i]}" "${gitweb_folder}"/static/"${file[i]}".bak
    sudo cp "${gitweb_folder}"/gitweb_theme/"${file[i]}" "${gitweb_folder}"/static/"${file[i]}"
  done
}

restart_service() {
  sudo service fcgiwrap stop
  sudo service nginx stop
  sudo service fcgiwrap start
  sudo service nginx start
}

sudo apt install sudo wget nginx nginx-common git gitweb fcgiwrap highlight
nginx_file
gitweb_file
git_description
gitweb_theme
restart_service
