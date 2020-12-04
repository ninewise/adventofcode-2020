#!/bin/sh
entry=
{
	while read -r line || [ ! -z "$line" ]; do
		if [ -z "$line" ]
		then echo "$entry " && entry=
		else entry="$entry $line"
		fi
	done
	echo "$entry "
} < "$1" | #
	grep -E 'byr:(19[2-9][0-9]|200[012]) ' | #
	grep -E 'iyr:(201[0-9]|2020) ' | #
	grep -E 'eyr:(202[0-9]|2030) ' | #
	grep -E 'hgt:(1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in) ' | #
	grep -E 'hcl:#[0-9a-f]{6} ' | #
	grep -E 'ecl:(amb|blu|brn|gry|grn|hzl|oth) ' | #
	grep -E 'pid:[0-9]{9} ' | #
	wc -l
