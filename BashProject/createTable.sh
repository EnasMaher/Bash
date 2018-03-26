#!/usr/bin/sh
existTable=0
function createTable {
if [ ! -f $1 ]
then
touch $1
else
echo "This table already exists"
existTable=1
fi
}

