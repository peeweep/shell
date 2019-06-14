#!/bin/bash

clone() {
  rm -rf "${repo_folder}"
  git clone --bare "${repo_url}" "${repo_folder}"
}

contrast() {
  current_packed_refs=$(awk <"${repo_folder}"/packed-refs 'NR==2{print $1}')
  newest_commit=$(curl -s "${repo_url}"/commits/master.atom | grep Commit | sed -n 2p)
  echo "${newest_commit}" >"${curDate}"newest_commit

  if grep "${current_packed_refs}" "${curDate}"newest_commit; then
    echo "newest, exiting"
    rm "${curDate}"newest_commit
    exit 1
  else
    echo "begin remove old folder and clone the new one"
    rm "${curDate}"newest_commit
    clone
  fi
}

curDate=$(date +%Y%m%d%H%M%S)
gitweb_folder="/gitweb"
repo_folder="${gitweb_folder:?}/$2.git"
repo_url="https://github.com/$1/$2"

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

# crontab: */1 * * * * /bin/bash /usr/bin/gitweb_sync user_name repository

