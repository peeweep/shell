#!/usr/bin/bash

init() {
  echo -n "Enter the origin folder: "
  read origin_folder
  echo "The origin folder is setting as ${origin_folder}"
  echo "Make sure your team drive named as 1 2 3 ..."
  echo -n "choose the user_node your start ( 1 / 2 / 3): "
  read user_node
  rm rclone.log
  rclone copy ${origin_folder} ${user_node}:${origin_folder} --rc -vv -P
  echo "rclone copy ${origin_folder} ${user_node}:${origin_folder}  --rc -vv -P" >>rclone.log
  echo
}
get_bytes() {
  curTime=$(date +%Y%m%d%H%M%S)
  rclone rc core/stats >>pid_${curTime}.txt
  bytes=$(awk -F '"' '{print $3}' pid_${curTime}.txt | awk -F" " '{print $2}' | awk -F, '{print $1}' | sed -n 2p)
  echo ${bytes}
}

is_restart() {
  get_bytes
  limit_700g='700000000000'
  if [ ${bytes} -ge ${limit_700g} ]; then
    pid=$(rclone rc core/pid)
    kill -s 9 ${pid}
    origin_folder=$(awk '{print $3}' rclone.log)
    user_node=$(awk '{print $4}' rclone.log | awk -F: '{print $1}')
    user_node=$((user_node + 1))
    rclone copy ${origin_folder} ${user_node}:${origin_folder} --rc -vv -P
    echo "rclone copy ${origin_folder} ${user_node}:${origin_folder} --rc -vv -P" >>rclone.log
  fi
}

check_log() {
  rclone_log="rclone.log"
  if [ ! -f "${rclone_log}" ]; then
    echo "********************************"
    echo "* Rclone.log not found."
    echo "* Initializing settings"
    echo "********************************"
    init
  else
    is_restart
  fi
}

check_log

# crontab
# */10 * * * * /usr/bin/bash rclone_monitor.sh
