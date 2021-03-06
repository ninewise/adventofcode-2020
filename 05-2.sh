#!/bin/sh
bin2dec() {
	tr '\n' '_' | {
		n=0
		while c="$(head -c 1)" && [ "$c" != "" ]; do
			case "$c" in
			0) n="$(( (n << 1) ))" ;;
			1) n="$(( (n << 1) + 1 ))" ;;
			_) echo "$n" && n=0 ;;
			esac
		done
		echo "$n"
	}
}

# using bc
bin2dec() {
	{ echo "ibase=2" && cat; } | bc
}

tr 'BFRL' '1010' < "$3" | sort | bin2dec | {
	read prev
	while read n; do
		if [ "$(( n - prev ))" = 2 ]; then
			echo "$(( n - 1 ))"
		fi
		prev="$n"
	done
}
