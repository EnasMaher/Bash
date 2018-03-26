#!/usr/bin/sh
currentLocation=${PWD}
Tables=$(ls -f $currentLocation/*)
for file in $currentLocation/*
do
echo ${file##*$currentLocation/}
done

