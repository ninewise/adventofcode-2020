#!/bin/sh
bin2dec() {
	n=0
	while c="$(head -c 1)" && [ ! -z "$c" ]; do
		case "$c" in
		0) n="$(( (n << 1) ))" ;;
		1) n="$(( (n << 1) + 1 ))" ;;
		*) echo "$n" && n=0 ;;
		esac
	done
	echo "$n"
}

tr 'BFRL' '1010' < "$1" | sort | tail -1 | bin2dec
