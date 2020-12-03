#!/bin/sh
height="$(wc -l < 03-input)"
width="$(head -1 < 03-input | tr -d '\n' | wc -c)"
for x in $(seq 0 "$height"); do
	y="$(( (3 * x) % width ))"
	head -c "$y" > /dev/null
	head -c 1
	head -1 > /dev/null
done < 03-input | tr -d '.' | wc -c
