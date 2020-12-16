#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL

mkfifo "$d/ranges"
grep -o '[0-9]\+-[0-9]\+' "$3" | sed 's/-/ /' > "$d/ranges" &

sed '1,/nearby tickets/d' "$3" | tr ',' '\n' > "$d/a"

while read from to || [ ! -z "$from" ]; do
	while read number || [ ! -z "$number" ]; do
		if [ "$number" -lt "$from" -o "$number" -gt "$to" ]; then
			echo "$number"
		fi
	done < "$d/a" > "$d/b"
	mv "$d/b" "$d/a"
done < "$d/ranges"

tr '\n' '+' < "$d/a" | sed 's/+$/\n/' | bc
