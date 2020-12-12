#!/bin/sh
height="$(wc -l < "$3")"
height="$(( height + 1 ))"
width="$(head -1 "$3")"
width="${#width}"

around() {
	r="$1"
	c="$2"
	head -"$(( r - 1 ))" > /dev/null # smaller rows
	head -c"$(( c - 1 ))" > /dev/null # smaller columns
	head -c3
	head -1 > /dev/null # rest of the line
	head -c"$(( c - 1 ))" > /dev/null # smaller columns
	head -c1 # left of the marker
	head -c1 > /dev/null # the marker
	head -c1 # right of the marker
	head -1 > /dev/null # rest of the line
	head -c"$(( c - 1 ))" > /dev/null # smaller columns
	head -c3
}

count() {
	tr -cd "$1" | wc -c
}

f1="$(mktemp)"
f2="$(mktemp)"
yes '.' | head -"$(( width + 2 ))" | tr -d '\n' >> "$f2"
echo >> "$f2"
sed 's/.*/.&./' "$3" >> "$f2"
if [ ! -z "$(tail -c1 "$3")" ]; then echo >> "$f2"; fi
yes '.' | head -"$(( width + 2 ))" | tr -d '\n' >> "$f2"
echo >> "$f2"

while ! diff -q "$f1" "$f2"; do
	cat "$f2" > "$f1"
	{
		head -1
		for r in $(seq 1 "$height"); do
			head -c1
			for c in $(seq 1 "$width"); do
				case "$(head -c1)" in
				'L') if [ "$(around "$r" "$c" < "$f1" | count '#')" -eq 0 ]; then printf '#'; else printf 'L'; fi ;;
				'#') if [ "$(around "$r" "$c" < "$f1" | count '#')" -ge 4 ]; then printf 'L'; else printf '#'; fi ;;
				'.') printf '.' ;;
				esac
			done
			head -c2 # point and newline
		done
		head -1
	} < "$f1" > "$f2"
	cat "$f2"
	echo
done

count '#' < "$f1"

rm "$f1" "$f2"
