#!/usr/bin/sh
currentLocation=${PWD}
DB=$(ls -d $currentLocation/*/)
for dir in $currentLocation/*/
do
echo ${dir##*BashProject/}
done
