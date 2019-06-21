#!/bin/bash

nginx_file() {
  nginx_file="/etc/nginx/conf.d/cgit.conf"
  example="example.com"
  sudo wget https://raw.githubusercontent.com/Lusty01/shell/master/cgit/conf/nginx.conf -O ${nginx_file}
  echo "enter your server_name for nginx config file, default: example.com"
  read -r server_name
  [[ -z "${server_name}" ]] && server_name="example.com"
  sudo sed -i "s/${example}/${server_name}/g" ${nginx_file}
}

cgit_file() {
  default_projectroot='/srv/git'
  cgit_file="/etc/cgitrc"
  sudo wget https://raw.githubusercontent.com/Lusty01/shell/master/cgit/conf/custom_cgit.conf -O ${cgit_file}
  echo "enter your cgit projectroot, default: /cgit"
  read -r projectroot
  [[ -z "${projectroot}" ]] && projectroot='/cgit'
  sudo mkdir -p ${projectroot}
  sudo chmod 777 ${projectroot}
  sudo sed -i "s|${default_projectroot}|${projectroot}|" ${cgit_file}
}

git_description() {
  echo "enter your default description for all projects, default: no description"
  read -r description
  [[ -z "${description}" ]] && description='no description'
  description_file="/usr/share/git-core/templates/description"
  sudo rm ${description_file}
  echo "${description}" | sudo tee ${description_file}
}

restart_service() {
  sudo service fcgiwrap stop
  sudo service nginx stop
  sudo service fcgiwrap start
  sudo service nginx start
}

sudo apt install wget nginx nginx-common git cgit fcgiwrap
nginx_file
cgit_file
git_description
restart_service
