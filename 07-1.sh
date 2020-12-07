#!/bin/sh
f="$(mktemp)"
b="$(mktemp)"
grep ' shiny gold' "$3" | sed 's/\(.*\) bags contain.*/ \1/' > "$b"
while [ -s "$b" ]; do
	cat "$b" "$f" | sort | uniq | sponge "$f"
	grep -f "$b" "$3" | sed 's/\(.*\) bags contain.*/ \1/' | sponge "$b"
done
wc -l "$f"
rm "$f" "$b"
