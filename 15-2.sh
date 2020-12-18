#!/bin/sh
d="$(mktemp -d)"

tr ',' '\n' < "$3" | sed '$d' | cat -n | while read i n || [ ! -z "$i" ]; do
	echo "$i" > "$d/$n"
done

i="$(tr ',' '\n' < "$3" | wc -l)"
spoken="$(sed 's/.*,//' "$3")"

for i in $(seq "$(( i + 1 ))" 29999999); do
	#head "$d"/* | sed '/^$/d' | sed '/=/N;s/\n//'
	#echo "spoken=$spoken"
	memory="$(cat "$d/$spoken" 2>/dev/null)"
	echo "$i" > "$d/$spoken"
	if [ -z "$memory" ]; then
		spoken=0
	else
		spoken="$(( i - memory ))"
	fi
	case "$i" in
	*0000) printf '[%s] %d\n' "$(date)" "$i" ;;
	esac
	#echo "$((i + 1)) --> $spoken"
	#sleep 5
done
echo "$((i + 1)) --> $spoken"

rm -r "$d"
