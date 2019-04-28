#!/bin/bash
username='xxx'
foldername='xxx'
folderid='xxx'
yearfolder="$foldername/$username/$(date +%Y)"
datefolder= "$foldername/$username/$(date +%Y)/$(date +%Y%m)/$(date +%Y%m%d)"
archive_fileName="$datefolder/$(date +%Y%m%d%H%M%S).7z"
mkdir -p $datefolder
cd $datefolder
curl -s "https://api.github.com/users/$username/repos?per_page=100" | jq -r ".[].git_url" | xargs -L1 git clone
7z a $archive_fileName $foldername
cd $foldername
ls | grep -v $(date +%Y) | xargs rm -rf
gdrive upload --parent $folderid -r $yearfolder
rm -rf $foldername
