#!/bin/bash
MYPATH="$1"
command -v $MYPATH/fillit >/dev/null 2>&1 || { echo "Don't find fillit!\nNOTE: \033[0;31m0 / 42\033[0m"; exit 1; }
echo "fillit_checker by agadhgad"
LOCALPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
nb=0
function test_error()
{

i=0
echo "--- begin of invalid test ---"
echo "\033[0;31mWARNING: stdout != stderr\033[0m"
while [ "$i" != 20 ]
do
	echo "invalid test $i : \c"
	var=$((${MYPATH}/./fillit ${LOCALPATH}/error_file/error_$i) 2>&-)
	if [ "$var" != "error" ]
	then
		echo "\033[0;31mfail :/\033[0m"
		echo "for the file error_$i (cat -e):"
		cat -e ${LOCALPATH}/error_file/error_$i
		echo "your output is:"
		echo "$var"
	else
		echo "\033[0;32mok\033[0m"
		nb=$((nb+1))
	fi
	i=$((i+1))
done
echo "--- end of invalid test ---"
if [ "$nb" != 20 ]
then
	echo "\033[0;31minvalid test failed, $nb / 20\033[0m"
else
	echo "\033[0;32minvalid test succeed, $nb / 20\033[0m"
fi

}
nb2=0
function test_valid()
{

i=0
echo "___ begin of valid test ___"
while [ "$i" != 20 ]
do
	echo "valid test $i : \c"
	var=$(${MYPATH}/./fillit ${LOCALPATH}/correct_file/valid_$i 2>&-)
	var2=$(cat "${LOCALPATH}/correct_compare/output_valid_$i")
	if [ "$var" != "$var2" ]
	then
		echo "\033[0;31mfail :/\033[0m"
		echo "WHAT IS EXPECTED:"
		echo "$var2"
		echo "YOUR OUPUT:"
		echo "$var"
	else
		echo "\033[0;32mok\033[0m"
		nb2=$((nb2+1))
	fi
	i=$((i+1))
done
echo "___ end of valid test ___"
if [ "$nb2" = 20 ]
then
	echo "\033[0;32mvalid test succeed $nb2 / 20\033[0m"
else
	echo "\033[0;31mvalid test failed, $nb2 / 20\033[0m"
fi

}

function bonus()
{

if [ "$nb" = 40 ]
then

	echo "\033[0;34mBONUS : \033[0m"
	time ${MYPATH}/./fillit ${LOCALPATH}/correct_file/valid_20
	time ${MYPATH}/./fillit ${LOCALPATH}/correct_file/valid_21
	echo "NOTE: \033[0;32m42/42\033[0m"
else
	echo "NOTE: \033[0;31m$nb / 40\033[0m"
fi

}

function main()
{

test_error
test_valid
(( nb += nb2))
bonus
}

main
