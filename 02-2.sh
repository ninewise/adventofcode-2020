#!/bin/sh
while read locations letter password || [ ! -z "$locations" ]; do
	fst="${locations%%-*}"
	snd="${locations##*-}"
	letter="${letter%:}"
	if printf "%s" "$password" | grep -qE "^.{$((fst-1))}($letter.{$((snd-fst-1))}[^$letter]|[^$letter].{$((snd-fst-1))}$letter)"; then
		printf "%d-%d %s: %s\n" "$fst" "$snd" "$letter" "$password"
	fi
done < "$1" | wc -l
