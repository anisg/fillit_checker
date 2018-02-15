#!/bin/bash
MYPATH="$1"
command -v $MYPATH/fillit >/dev/null 2>&1 || { echo "Don't find fillit!\nNOTE: \033[0;31m0 / 46\033[0m"; exit 1; }
echo "fillit_checker by agadhgad"
LOCALPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# nb of total valid test
nb=0

# $1: i
function error_put()
{
	echo "for the file error_$1 (cat -e):"
	cat -e ${LOCALPATH}/error_file/error_$1
	echo "your output is:"
}
function valid_put()
{
	echo "WHAT IS EXPECTED:"
	cat "${LOCALPATH}/correct_compare/output_valid_$1"
	echo "YOUR OUTPUT:"
}

i=0
# $1: type test $2: pathfolder&name $3: number of test arg $4: var2 $5: 1 if var2 take i for arg, else 0 $6 fnctn error
function test()
{
	test_nb=0
	i=0
	echo "--- begin of $1 test ---"
	while [ "$i" != $3 ]
	do
		echo "$1 test $i : \c"
		var=$((${MYPATH}/./fillit ${LOCALPATH}/$2$i) 2>&-)
		if [ "$5" == 1 ]
		then
			var2=$($4$i)
		else
			var2=$($4)
		fi
		# echo "$var2"
		if [ "$var" != "$var2" ]
		then
			echo "\033[0;31mfail :/\033[0m"
			$6 $i
			echo "$var"
		else
			echo "\033[0;32mok\033[0m"
			test_nb=$((test_nb+1))
		fi
		i=$((i+1))
	done
	echo "--- end of $1 test ---"
	if [ "$test_nb" != $3 ]
	then
		echo "\033[0;31m$1 test failed, $test_nb / $3\033[0m"
	else
		echo "\033[0;32m$1 test succeed, $test_nb / $3\033[0m"
	fi
	nb=$((nb+test_nb))
}

function bonus()
{
	if [ "$nb" = 46 ]
	then
		echo "\033[0;34mBONUS : \033[0m"
		time ${MYPATH}/./fillit ${LOCALPATH}/correct_file/valid_20
		time ${MYPATH}/./fillit ${LOCALPATH}/correct_file/valid_21
		echo "NOTE: \033[0;32m48/48\033[0m"
	else
		echo "NOTE: \033[0;31m$nb / 46\033[0m"
	fi
}

function main()
{
	make re -C ${MYPATH}
	test invalid "error_file/error_" 26 "echo "error"" 0 error_put
	test valid "correct_file/valid_" 20 "cat ${LOCALPATH}/correct_compare/output_valid_" 1 valid_put
	bonus
}

main
