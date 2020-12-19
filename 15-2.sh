#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL

# Prepare map
mkfifo "$d/in"
mkfifo "$d/out"
./map < "$d/in" > "$d/out" &
exec 3> "$d/in" 4< "$d/out"

tr ',' '\n' < "$3" | sed '$d' | cat -n | while read i n || [ ! -z "$i" ]; do
	echo put "$n" "$i" >&3
done

i="$(tr ',' '\n' < "$3" | wc -l)"
i="$(( i + 1 ))"
spoken="$(sed 's/.*,//' "$3")"

while [ "$i" -lt 30000000 ]; do
	memory="$(echo get "$spoken" >&3 && head -1 <&4)"
	echo put "$spoken" "$i" >&3
	if [ -z "$memory" ]; then
		spoken=0
	else
		spoken="$(( i - memory ))"
	fi
	if [ "$(( i % 10000 ))" -eq 0 ]; then
		printf '[%s] %d\n' "$(date)" "$i"
	fi
	i="$(( i + 1 ))"
done
echo "$i --> $spoken"
