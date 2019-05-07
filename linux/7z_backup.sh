#!/bin/bash
7z a $(date +%Y%m%d%H%M%S).7z folder_name
gdrive upload *.7z  -p folder_id
rm *.7z
