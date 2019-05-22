#!/usr/bin/bash
rm -rf /your_Google_drive_mount_path
mkdir -p /your_Google_drive_mount_path
rclone mount your_rclone_account: /your_Google_drive_mount_path --allow-other --allow-non-empty --vfs-cache-mode writes

