#!/usr/bin/sh
function createTable {
if [ ! -f $1 ]
then
touch $1
else
echo "This table already exists"
fi
}

