#!/bin/sh
# required jq
# for i in {1..264}
for i in {1..2} ; do 
  curl -s http://adr.meizitu.net/wp-json/wp/v2/posts\?page\=$i\&per_page\=20 | jq -r '.[] | .thumb_src' | xargs -IX curl -s -O X
  mkdir $i && mv *.jpg $i
  echo FinishPage$i
done
