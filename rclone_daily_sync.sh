#!/bin/bash

source_name="custom your source name"
target_name="custom your target name"
rclone lsd "${source_name}": | tee /tmp/task_list
folder_list=$(awk -F " " '{print $5}' task_list)

save_bytes() {
  curTime=$(date +%Y%m%d%H%M%S)
  rclone rc core/stats >>pid_"${curTime}".txt
  bytes=$(awk -F '"' '{print $3}' pid_"${curTime}".txt | awk -F" " '{print $2}' | awk -F, '{print $1}' | sed -n 2p)
  limit_700g='700000000000'
  # '-ge': >=
  if [ "${bytes}" -ge ${limit_700g} ]; then
    pid=$(rclone rc core/pid)
    kill -s 9 "${pid}"
    exit 1
  fi
}

is_skip() {
  if [[ ! ${folder} == "$1" ]]; then
    echo "skip"
  else
    rclone sync "${source_name}:${folder}" "${target_name}:${folder}" --rc -P
    save_bytes
  fi
}

rclone_start() {
  arr=("$folder_list")
  for folder in ${arr[*]}; do
    is_skip "视频"
  done
}

rclone_start

# usage:
# crontab:
# * 1 * * * /usr/bin/bash rclone_daily_sync.sh
