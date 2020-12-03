#!/bin/sh
while read range letter password || [ ! -z "$range" ]; do
	atleast="${range%%-*}"
	atmost="${range##*-}"
	letter="${letter%:}"
	filtered="$(printf "%s" "$password" | tr -cd "$letter")"
	if [ "$atleast" -le "${#filtered}" -a "${#filtered}" -le "$atmost" ]; then
		printf "%d-%d %s: %s\n" "$atleast" "$atmost" "$letter" "$password"
	fi
done < "$1" | wc -l
