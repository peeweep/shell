#!/usr/bin/bash

echo -n "Enter the origin folder: "
read origin_folder
echo "The origin folder is setting as ${origin_folder}"
echo "Make sure your team drive named as 1 2 3 ..."
echo -n "choose the user_node your start:( 1 / 2 / 3) "
read user_node
rm rclone.log
rclone copy ${origin_folder} ${user_node}:${origin_folder} --rc -vv -P
echo "rclone copy ${origin_folder} ${user_node}:${origin_folder}  --rc -vv -P" >>rclone.log
echo
