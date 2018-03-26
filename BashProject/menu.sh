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

select ch in "Create table" "Insert into table" "Update table" "Delete table" "Display table" "Exit"
do
case $ch in
"Create table")
. ./checkName.sh
if [[ $valid -eq 1 ]]
then
	cd $usedDBName
	nameOfTable=""
	numberOfCol=0
	PrimaryKey=""
	source $DBpath/createTable.sh
	createTable $REPLY
	if [[ ! existTable -eq 1 ]]
	then
	nameOfTable=$REPLY
	read -p "Enter number of columns"
	di='^[0-9]+$'
	while [[ ! $REPLY =~ $di ]] || [[ $REPLY -eq 0 ]]
	do
	read -p "Enter number of columns"
	done
	numberOfCol=$REPLY
	echo $numberOfCol >> $nameOfTable 
NameOfColumns=()
DataTypes=()
Keys=()
while [ ! $numberOfCol -eq 0 ]
do
source $DBpath/checkName.sh
	if [[ $valid -eq 1 ]]
	then
	#echo $REPLY >> $nameOfTable
	nameOfCol=$REPLY
	NameOfColumns+=($nameOfCol)
	read -p "Enter the Data type (number/string)"
	echo "$REPLY"
while [[ $REPLY != number ]] && [[ $REPLY != string ]]
do
	read -p "Enter the Data type (number/string)"
	echo $REPLY
done
	if [ $REPLY = number -o $REPLY = string ]
	then
	#echo $REPLY >> $nameOfTable
	DataTypes+=($REPLY)
	fi
if [[ $PrimaryKey = "" ]]
then
read -p "IS this the PrimaryKey (y/n)"
	while [[ $REPLY != y ]] && [[ $REPLY != n ]]
	do
	read -p "IS this the PrimaryKey (y/n)"
	done
	if [[ $REPLY = y ]]
	then
	PrimaryKey=$nameOfCol
	#echo "P" >> $nameOfTable
	Keys+=('P')
	else
        Keys+=('NP')
	fi

fi

let numberOfCol=$numberOfCol-1
echo "number of Columns $numberOfCol"
fi
done
echo $PrimaryKey 
if [[ $PrimaryKey = "" ]]
then
#echo "P" >> $nameOfTable
Keys[0]='P'
fi
length=${#NameOfColumns[@]}
echo $length
counter=0
while [[ ! counter -eq $length ]]
do
echo -n "c:${NameOfColumns[$counter]}(${DataTypes[$counter]})(${Keys[$counter]})	" >> $nameOfTable
let counter=$counter+1
done
fi
cd $DBpath
fi
;;
"Insert into table")
cd $usedDBName
source $DBpath/existTables.sh
source $DBpath/checkName.sh
if [[ ! -f $REPLY ]]
then
echo "There is no such table"
else
source $DBpath/insertInto.sh
fi 
cd $DBpath
;;
"Update table")
echo "update"
;;
"Delete table")
cd $DBpath/$usedDBName
source $DBpath/deleteTable.sh
;;
"Display table")
cd $DBpath/$usedDBName
source $DBpath/existTables.sh
source $DBpath/checkName.sh
if [[ ! -f $REPLY ]]
then
echo "There is no such table"
else
cat $REPLY | tr ";" " " | tr "v:" " " | tr "c:" " " | tail -n +2 
fi
cd $DBpath
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
