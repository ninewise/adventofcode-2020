#!/bin/sh
f="$(mktemp)"
f2="$(mktemp)"
printf '1 shiny gold\n' > "$f"
total=0
while [ -s "$f" ]; do
	bags="$(sed 's/ [^*]*$//' "$f" | tr '\n' '+' | sed 's/+$/\n/' | bc)"
	while read -r c e; do
		grep "$e bags contain" "$3" | sed 's/.*contain //;s/\.//;s/, /\n/g;s/ bags*//g' | sed "s/^/$c*/"
	done < "$f" > "$f2"
	sed '/no other/d' "$f2" > "$f"
	total="$(( total + bags ))"
done
echo "$(( total - 1 ))"
rm "$f" "$f2"
