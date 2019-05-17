#!/bin/bash
curDate=$(date +%Y%m%d%H%M%S)
path_name='/path_name'
folder_name='folder_name'
folder_id='folder_id'
7z a "$path_name"/"$curDate".7z "$path_name"/"$folder_name" 
gdrive upload "$path_name"/"$curDate".7z  -p "$folder_id"
rm "$path_name"/"$curDate".7z
