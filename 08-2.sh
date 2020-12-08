#!/bin/sh
execute() {
	acc=0
	isp=0
	lines="$(wc -l < "$1")"
	while [ "$isp" -lt "$lines" ]; do
		line="$(sed -n "$(( isp + 1 ))p" "$1")"
		sed -i "$(( isp + 1 ))s/.*//" "$1"
		incr="${line##* }"
		case "${line%% *}" in
		nop) isp="$(( isp + 1 ))" ;;
		acc) acc="$(printf '%s%s\n' "$acc" "$incr" | bc)" && isp="$(( isp + 1 ))" ;;
		jmp) isp="$(printf '%s%s\n' "$isp" "$incr" | bc)" ;;
		*)   echo "$acc" && exit 1;;
		esac
	done
	echo "$acc"
	exit 0
}

f="$(mktemp)"
for change in $(cat -n "$3" | grep -v 'acc' | sed 's/\t.*//'); do
	sed "${change}{/nop/s/nop/jmp/;/jmp/s/jmp/nop/}" "$3" > "$f"
	if result="$(execute "$f")"; then
		echo "$result"
		exit
	fi
done
