#!/bin/sh
sed '$!{/./{H;d}};x;s/\n/ /g;s/$/ /' "$1" | #
sed -n '/byr:\(19[2-9][0-9]\|200[012]\) /p' | #
sed -n '/iyr:\(201[0-9]\|2020\) /p' | #
sed -n '/eyr:\(202[0-9]\|2030\) /p' | #
sed -n '/hgt:\(1[5-8][0-9]cm\|19[0-3]cm\|59in\|6[0-9]in\|7[0-6]in\) /p' | #
sed -n '/hcl:#[0-9a-f]\{6\} /p' | #
sed -n '/ecl:\(amb\|blu\|brn\|gry\|grn\|hzl\|oth\) /p' | #
sed -n '/pid:[0-9]\{9\} /p'
