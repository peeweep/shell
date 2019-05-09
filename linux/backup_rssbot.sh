#!/bin/bash
curDate=$(date +%Y%m%d%H%M%S)
pathname='/root'
folder_name='rssbot'
folder_id='16P2064P2d2SPGaSUfF4wS9JNqJ_MRAZv'
7z a "$pathname"/"$curDate".7z "$pathname"/"$test" 
gdrive upload "$pathname"/"$curDate".7z  -p "$folder_id"
rm "$pathname"/"$curDate".7z
