#!/usr/bin/sh
DBpath=${PWD}
usedDBName=""
select item in "Create Database" "Use Exist Database" "Delete Database" "Exit"
do
case $item in
"Create Database")
. ./checkName.sh
if [[ $valid -eq 1 ]]
then
. ./createDB.sh
createDB $REPLY
fi
;;
"Use Exist Database")
. ./existDB.sh
read -p "choose the Database you want to use"
if [[ -d $REPLY ]]
then
usedDBName=$REPLY

select ch in "Create table" "Insert into table" "Update table" "Delete table" "Exit"
do
case $ch in
"Create table")
. ./checkName.sh
if [[ $valid -eq 1 ]]
then
cd $usedDBName
source $DBpath/createTable.sh
createTable $REPLY
cd $DBpath
fi
;;
"Insert into table")
echo "insert"
;;
"Update table")
echo "update"
;;
"Delete table")
cd $usedDBName
source $DBpath/deleteTable.sh
;;
"Exit")
cd $DBpath
echo "1) Create Database"
echo "2)Use Exist Database" 
echo "3)Delete Database" 
echo "4)Exit"
break 
;;
*)
echo "not available choice"
;;
esac
done
else
echo "There's no Database with this name"
fi
;;
"Delete Database")
. ./deleteDatabase.sh
;;
"Exit")
exit
;;
*) 
echo "not of available choices"
esac
done
