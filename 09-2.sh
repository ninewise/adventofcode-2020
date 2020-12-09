#!/bin/sh
invalid="$(./09-1.sh "$@")"
sum=0
buffer="$(mktemp)"
exec < "$3"
while [ "$sum" != "$invalid" ]; do
	if [ "$sum" -lt "$invalid" ]; then
		line="$(head -1)"
		sum="$(( sum + line ))"
		printf '%s\n' "$line" >> "$buffer"
	else
		line="$(head -1 "$buffer")"
		sum="$(( sum - line ))"
		sed -i '1d' "$buffer"
	fi
done

sort -n "$buffer" | sed -n '1p;$p' | tr '\n' '+' | sed 's/+$/\n/' | bc
