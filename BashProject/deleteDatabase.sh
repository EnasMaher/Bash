#!/usr/bin/sh
read -p "choose the Database you want to delete"
if [[ -d $REPLY ]]
then
rm -r $REPLY
else
echo "No such Database"
fi

