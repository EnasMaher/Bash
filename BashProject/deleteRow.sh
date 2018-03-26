#! /usr/bin/sh
currentPath=${PWD}
TableName=$REPLY
numberOfCol=$(head -n 1 $TableName)
counter=1
names=()
DataTypes=()
Key=()
numberOfPKCol=-1

while [[ ! $counter -eq $numberOfCol+1 ]]
do
Key+=($(tail -n +2 $TableName| grep 'c:' | cut -f$counter |grep '(P)'| cut -d':' -f2 | cut -d '(' -f1))
if [[ ${#Key[@]} -gt 0 ]] && [[ $numberOfPKCol -eq -1 ]]
then 
numberOfPKCol=$counter
echo $numberOfPKCol 
fi
let counter=$counter+1
done
echo "Enter the ${Key[0]}"
read
numberOfRow=$(cut -f$numberOfPKCol $TableName | grep -n $REPLY | cut -d':' -f1)
sed  -n "$numberOfRow d" $TableName


