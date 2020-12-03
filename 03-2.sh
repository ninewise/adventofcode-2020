#!/bin/sh
inputfile="$1"
height="$(wc -l < "$inputfile")"
width="$(head -1 < "$inputfile" | tr -d '\n' | wc -c)"

count() {
	xskip="$1"
	yskip="$2"
	for x in $(seq 0 "$height"); do
		y="$(( (xskip * x) % width ))"
		head -c "$y" > /dev/null
		head -c 1
		head -1 > /dev/null
		for _ in $(seq "$(( yskip - 1 ))"); do head -1 > /dev/null; done
	done < "$inputfile" | tr -d '.' | wc -c
}

echo "$(( $(count 1 1) * $(count 3 1) * $(count 5 1) * $(count 7 1) * $(count 1 2) ))"
