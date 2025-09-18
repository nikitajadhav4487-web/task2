

echo -e "enter num:\c"
read a b 
echo "a is :$a b is :$b"

if [ $a -gt $b ]
then
	echo "a is greter than b"
	if [ $((a % 2)) -eq 0 ]
	then
		echo " a is even"
	fi
else
	echo "a is less than b"
fi

echo "enter file name:"
read name

if [ -e $neme ]
then
	echo "file is present"
	if [ -f $name ]
	then
		echo "file is regular"
	else 
		echo "file  is not regular"
	fi
else
	echo "file is not present"
fi


