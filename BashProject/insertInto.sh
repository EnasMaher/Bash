#!/usr/bin/sh
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
echo ${#Key[@]}
echo "These the names of the columns Enter their values ${names[*]}"
echo ${DataTypes[*]}

notValidFlag=0
count=0
input=""
arr=()

while [[ ! count -eq ${#names[@]} ]]
do
	found=0
	if [[ ${names[count]} = ${Key[0]} ]]
	then
		let val=$count+1
		arr+=($(tail -n +2 $TableName |grep 'v:' | cut -d$'\t' -f$val | cut -d':' -f2))
		echo ${#arr[@]}
	fi
	read
REPLY=$(echo $REPLY | tr " " ';')
if [[ ${DataTypes[count]} = number ]]
then
	shopt -s extglob
	case $REPLY in
	+([[:digit:]]))
	echo $REPLY
		if [[ $count+1 -eq $numberOfPKCol ]]
		then 
		for item in ${arr[*]}
		do
			echo "item in array is $item"
			if [[ $item -eq $REPLY ]]
			then
			found=1
			fi 
		done
		
			if [[ $found -eq 0 ]]
			then
			input+="$REPLY	"
			else
			notValidFlag=1
			fi
		else
		input+="$REPLY	"
		fi
	
	;;
	"")
	if [[ $count+1 -eq $numberOfPKCol ]] 
	then 
		if [[ -z $REPLY ]] 
		then
			notValidFlag=1
			echo "Primary key can't be null"
		fi
	else
	input+="null	"
		
	fi
	;;
	*)
	echo "Not valid input"
	notValidFlag=1
	;;
	esac
elif [[ ${DataTypes[count]} = string ]]
then
	echo $REPLY
	
	if [[ $count+1 -eq $numberOfPKCol ]] 
	then 
		if [[ -z $REPLY ]] 
		then
			notValidFlag=1
			echo "Primary key can't be null"
		fi
	for item in ${arr[*]}
	do
		echo "item in array is $item"
		if [[ $item = $REPLY ]]
		then
			found=1
		fi 
	done
		if [[ $found -eq 0 ]]
		then
		input+="$REPLY	"
		else
		notValidFlag=1
		fi
	elif [[ -z $REPLY ]]
	then 
		input+="null	"
	else
		input+="$REPLY	"
	fi
fi
let count=$count+1
done

if [[ $notValidFlag -eq 0 ]]
then
echo "v:$input" >> $TableName
fi
echo ${Key[@]}


