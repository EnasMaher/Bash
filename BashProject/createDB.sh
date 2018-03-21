#!/usr/bin/sh
function createDB {
if [ ! -d $1 ]
then
mkdir $1
else
echo "it already exists"
fi
}
