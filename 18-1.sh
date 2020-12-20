#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL
mkfifo "$d/pasted"
mkfifo "$d/escaped"

sed 's/.*/(&)/' "$3" > "$d/edit"

# fout: 3 * (7 * (5 * 8 + 4)) * 5 + (9 + 9 * 5 + 8 + (6 * 4 + 2 * 2)) + 9

while egrep -o '\([0-9]+ [+*] [0-9]+' "$d/edit" > "$d/expr"; do
	sed 's/\*/\\\\*/' "$d/expr" > "$d/escaped" &
	sed 's/(//' "$d/expr" | bc | paste - "$d/escaped" > "$d/pasted" &
	while read value expr; do
		#echo "$expr" >> testfile
		sed -i "s/$expr\([ )]\)/($value\1/g" "$d/edit"
	done < "$d/pasted"
	#less "$d/edit"
	sed -i 's/(\([0-9]*\))/\1/' "$d/edit"
done

tr '\n' '+' < "$d/edit" | sed 's/+*$/\n/' | bc
