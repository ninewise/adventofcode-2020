#!/bin/sh
preamble=25
buffer="$(mktemp)"
exec < "$3"
head -"$preamble" > "$buffer"
while line="$(head -1)" && [ ! -z "$line" ]; do
	if ! join -j 2 "$buffer" "$buffer" -t + -o '1.1 2.1' | bc | grep -q "$line"; then
		echo "$line"
		exit
	fi
	sed -i 1d "$buffer"
	printf '%s\n' "$line" >> "$buffer"
done
rm "$buffer"
