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
names+=( $(tail -n +2 $TableName|grep 'c:' | cut -f$counter   |  cut -d':' -f2  | cut -d'(' -f1 ))
DataTypes+=($(tail -n +2 $TableName|grep 'c:' | cut -f$counter |cut -f2 -d'(' | cut -f1 -d')'))
Key+=($(tail -n +2 $TableName| grep 'c:' | cut -f$counter |grep '(P)'| cut -d':' -f2 | cut -d '(' -f1))
if [[ ${#Key[@]} -gt 0 ]] && [[ $numberOfPKCol -eq -1 ]]
then 
numberOfPKCol=$counter
echo $numberOfPKCol 
fi
let counter=$counter+1
done
echo "Enter the ${Key[0]}"
read pkCol
echo "These're the names of the columns ${names[*]}"
echo ${DataTypes[*]}
echo "Enter the name of column you want to update it"
read columnName
echo "Enter the new value"
read value
index=0
inValidFlag=0
count=0
input=""
found=0
arr=()
arr=$(tail -n +2 $TableName|sed "s/"v:"//g"|grep -v "c:" | cut -f$numberOfPKCol)
echo ${arr[*]}

while [[ ! $index -eq ${#names[*]} ]]
do
value=$(echo $value | tr " " ';')
if [[ $columnName = ${names[index]} ]] 
then
	if [[ $index+1 -eq $numberOfPKCol ]]
	then
		if [[ -z $value ]]
		then
			inValidFlag=1
		else
		for item in ${arr[*]}
		do
			if [[ ${DataTypes[index]} = number ]]
			then
				if [[ $item -eq $value ]]
				then
					found=1
					inValidFlag=1
					
				fi
			elif [[ ${DataTypes[index]} = string ]]
			then
				if [[ $item = $value ]]
				then
					found=1
					inValidFlag=1
				fi
			fi


		done
			
		fi	
	fi
	if [[ ${DataTypes[index]} = number ]] && [[ $inValidFlag -eq 0 ]] && [[ $found -eq 0 ]] 
	then
	shopt -s extglob
	case $value in
	+([[:digit:]]))
		input+=$value
	;;
	"")
	input+="null"
	;;
	*)
	echo "invalid value"
	inValidFlag=1
	;;
	esac
	elif [[ ${DataTypes[index]} = string ]] && [[ $inValidFlag -eq 0 ]] && [[ $found -eq 0 ]]
	then
		if [[ -z $value ]]
		then
		input+="null"
		else
		value=$(echo $value | tr " " ";")
		input+=$value
		fi
		
	fi
break
fi
let index=$index+1
done
if [[ $inValidFlag -eq 0 ]]
then
numberOfRow=$(cut -f$numberOfPKCol $TableName |tr ";" " "|sed "s/"v:"//g"|grep -n "^$pkCol" | cut -d':' -f1)
if [[ ! -z $numberOfRow ]]
then
let index=$index+1
oldValue=$(sed -n "$numberOfRow p" $TableName| sed "s/v://g" | cut -f$index) 
echo $oldValue
updatedRow="$(sed -n "$numberOfRow p" $TableName|sed "s/$oldValue/$input/g")" 
echo "$updatedRow" >> $TableName
touch tmp
sed "$numberOfRow d" $TableName >> tmp
rm $TableName
mv tmp $TableName
fi
fi




