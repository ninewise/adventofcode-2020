#!/bin/sh
acc=0
isp=0
f="$(mktemp)"
cat "$3" > "$f"
while true; do
	line="$(sed -n "$(( isp + 1 ))p" "$f")"
	sed -i "$(( isp + 1 ))s/.*//" "$f"
	incr="${line##* }"
	case "${line%% *}" in
	nop) isp="$(( isp + 1 ))" ;;
	acc) acc="$(printf '%s%s\n' "$acc" "$incr" | bc)" && isp="$(( isp + 1 ))" ;;
	jmp) isp="$(printf '%s%s\n' "$isp" "$incr" | bc)" ;;
	*)   echo "$acc" && exit ;;
	esac
done
rm "$f"
