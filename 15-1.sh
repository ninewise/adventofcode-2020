#!/bin/sh
f="$(mktemp)"
yes '' | head -2020 > "$f"

tr ',' '\n' < "$3" | cat -n | while read i spoken || [ ! -z "$i" ]; do
	sed -i "$((spoken + 1))s/.*/$i/" "$f"
done

i="$(tr ',' '\n' < "$3" | wc -l)"
spoken="$(sed 's/.*,//' "$3")"

for i in $(seq "$(( i + 1 ))" 2019); do
	line="$(sed -n "$(( spoken + 1 ))p" "$f")"
	sed -i "$(( spoken + 1 ))s/.*/$i/" "$f"
	case "$line" in
	'') spoken=0 ;;
	*)  spoken="$(( i - line ))" ;;
	esac
done
echo "$((i + 1)) --> $spoken"

rm "$f"
