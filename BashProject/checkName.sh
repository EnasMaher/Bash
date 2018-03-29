#!/usr/bin/sh
valid=1
read -p "Enter the name : "
shopt -s extglob
case $REPLY in
+([[:digit:]])) 
echo "name can't be a number"
valid=0
;;
+("."))
echo "can't be dot"
valid=0
;;
esac
if [[ $valid -eq 1 ]]
then
pattern=" |'"
if [[ $REPLY =~ $pattern ]]
then
echo "name can't have spaces"
valid=0
elif [[ -z $REPLY ]]
then
echo "name can't be empty" 
valid=0
elif [[ $REPLY == [0-9]* ]]
then
echo "name can't start with number"
valid=0
fi
fi

