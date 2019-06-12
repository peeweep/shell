#!/bin/bash

clone() {
  rm -rf "${repo_folder}"
  git clone --bare "${repo_url}"
}

contrast() {
  current_packed_refs=$(awk <"${repo_folder}"/packed-refs 'NR==2{print $1}')
  newset_commit=$(curl -s "${repo_url}"/commits/master.atom | grep Commit | sed -n 2p)
  echo "${newset_commit}" >"${curDate}"newset_commit

  if grep "${current_packed_refs}" "${curDate}"newset_commit; then
    echo "newest, exiting"
    exit 1
  else
    echo "begin remove old folder and clone the new one"
    clone
  fi
}

curDate=$(date +%Y%m%d%H%M%S)
gitweb_folder="/gitweb"
repo_folder="${gitweb_folder:?}/$1.git"
user_name="lusty01"
repo_url="https://github.com/${user_name}/$1"

network_status() {
  curl --connect-timeout 15 --max-time 20 --head --silent "${repo_url}" | grep '200 OK'
}
if ! network_status; then
  echo "timeout, exiting"
  exit 1
else
  echo "begin contrast "
  contrast
fi
