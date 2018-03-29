#!/usr/bin/sh
read -p "choose the table you want to delete : "
if [[ -f $REPLY ]]
then
rm $REPLY
else
echo "No such table"
fi

