#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL

yes "$(sed '/^$/,$d;s/ /_/g;s/:_/ /;s/-/ /g;s/_or_/ /' "$3" | tr '\n' '\t')" \
	| head -"$(sed '/^$/,$d' "$3" | wc -l)" \
	| tr '\t' '\n' \
	> "$d/ranges"

# find valid fields for each ticket column
mkfifo "$d/tickets"
sed -n 's/,/ /gp' "$3"> "$d/tickets" &
while read ticket || [ ! -z "$ticket" ]; do
	for number in $ticket; do
		while read name min1 max1 min2 max2 && [ ! -z "$name" ]; do
			if [ '(' "$min1" -le "$number" -a "$number" -le "$max1" ')' -o '(' "$min2" -le "$number" -a "$number" -le "$max2" ')' ]; then
				echo "$name $min1 $max1 $min2 $max2"
			fi
		done
		echo
	done < "$d/ranges" > "$d/reduced_ranges"
	if [ "$(wc -l < "$d/reduced_ranges")" -eq "$(uniq < "$d/reduced_ranges" | wc -l)" -a ! -z "$(head -1 "$d/reduced_ranges")"  ]; then
		mv "$d/reduced_ranges" "$d/ranges"
	fi # otherwise, ticket is invalid
done < "$d/tickets"

less "$d/ranges"

withwords() { echo "$#" "$@"; }
sed 's/ .*//;/^$/s/^/-/' "$d/ranges" | tr '\n-' ' \n' | sed '/^$/d' | cat -n | while read line; do
	withwords $line
done | sort -n > "$d/fields"

sed '1,/your ticket/d' "$3" | sed '/^$/,$d' | tr ',' '\n' > "$d/yourticket"

while [ -s "$d/fields" ]; do
	read words order field < "$d/fields"
	sed -i "1d;s/ $field//" "$d/fields"
	echo "$words $order $field" >&2
	if echo "$field" | grep -q departure; then
		printf '%d * ' "$(sed "$order!d" "$d/yourticket")"
	fi
done | sed 's/$/ 1\n/' | bc
