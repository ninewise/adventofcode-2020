#!/bin/sh
sed '$!{/./{H;d}};x;s/\n/ /g;s/$/ /;/byr:\(19[2-9][0-9]\|200[012]\) /!d;/iyr:\(201[0-9]\|2020\) /!d;/eyr:\(202[0-9]\|2030\) /!d;/hgt:\(1[5-8][0-9]cm\|19[0-3]cm\|59in\|6[0-9]in\|7[0-6]in\) /!d;/hcl:#[0-9a-f]\{6\} /!d;/ecl:\(amb\|blu\|brn\|gry\|grn\|hzl\|oth\) /!d;/pid:[0-9]\{9\} /!d' "$3" | wc -l
