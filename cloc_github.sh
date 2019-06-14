#!/usr/bin/bash
git clone "$1" temp_clone
cloc temp_clone
rm -rf temp_clone

