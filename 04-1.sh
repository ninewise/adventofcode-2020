#!/bin/sh
sed '$!{/./{H;d}};x;s/\n/ /g;s/$/ /' "$3" | #
sed -n '/byr:/p' | #
sed -n '/iyr:/p' | #
sed -n '/eyr:/p' | #
sed -n '/hgt:/p' | #
sed -n '/hcl:/p' | #
sed -n '/ecl:/p' | #
sed -n '/pid:/p'
