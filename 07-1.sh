#!/bin/sh
f="$(mktemp)"
f2="$(mktemp)"
b="$(mktemp)"
b2="$(mktemp)"
grep ' shiny gold' "$3" | sed 's/\(.*\) bags contain.*/ \1/' > "$b"
while [ -s "$b" ]; do
	cat "$b" "$f" | sort | uniq > "$f2"
	cat "$f2" > "$f"
	grep -f "$b" "$3" | sed 's/\(.*\) bags contain.*/ \1/' > "$b2"
	cat "$b2" > "$b"
done
wc -l "$f"
rm "$f" "$b" "$b2"
