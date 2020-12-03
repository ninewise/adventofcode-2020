#!/bin/sh
inputfile="$1"
height="$(wc -l < "$inputfile"
width="$(head -1 < "$inputfile" | tr -d '\n' | wc -c)"
for x in $(seq 0 "$height"); do
	y="$(( (3 * x) % width ))"
	head -c "$y" > /dev/null
	head -c 1
	head -1 > /dev/null
done < "$inputfile" | tr -d '.' | wc -c
