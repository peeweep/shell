#!/bin/bash
username='xxx'
foldername='xxx'
folderid='xxx'
archive_fileName="$foldername/$username$(date +%Y%m%d%H%M%S).7z"
echo"Create folder: $foldername"
mkdir -p $foldername
echo"Enter folder: $foldername"
cd $foldername/
echo"get $username\'s library"
curl -s "https://api.github.com/users/$username/repos?per_page=100" | jq -r ".[].git_url" | xargs -L1 git clone
echo"archive $archive_fileName"
7z a $archive_fileName $foldername
echo"upload $archive_fileName"
gdrive upload --parent $folderid $archive_fileName
echo"remove $foldername"
rm -rf $foldername
