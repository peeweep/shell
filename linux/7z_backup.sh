#!/bin/bash
curDate=$(date +%Y%m%d%H%M%S)
pathname='file_path'
folder_name='folder_name'
folder_id='google_drive_folder_id'
7z a "$pathname"/"$curDate".7z "$pathname"/"$test" 
gdrive upload "$pathname"/"$curDate".7z  -p "$folder_id"
rm "$pathname"/"$curDate".7z
