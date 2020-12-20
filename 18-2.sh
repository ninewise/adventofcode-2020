#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL
mkfifo "$d/pasted"
mkfifo "$d/escaped"

sed 's/.*/(&)/' "$3" > "$d/edit"

# fout: 3 * (7 * (5 * 8 + 4)) * 5 + (9 + 9 * 5 + 8 + (6 * 4 + 2 * 2)) + 9

while grep -q '[*+]' "$d/edit"; do
	# replace sums if possible
	if egrep -o '[0-9]+( \+ [0-9]+)+' "$d/edit" > "$d/expr"; then
		bc < "$d/expr" | paste - "$d/expr" > "$d/pasted" &
		while read value expr; do
			sed -i "s/\((\|\* \)$expr\()\| \*\)/\1$value\2/g" "$d/edit"
		done < "$d/pasted"
	fi

	# replace products within parens
	if egrep -o '\([0-9]+( \* [0-9]+)+\)' "$d/edit" > "$d/expr"; then
		sed 's/\*/\\\\*/g' "$d/expr" > "$d/escaped" &
		bc < "$d/expr" | paste - "$d/escaped" > "$d/pasted" &
		while read value expr; do
			sed -i "s/$expr/($value)/g" "$d/edit"
		done < "$d/pasted"
	fi

	sed -i 's/(\([0-9]*\))/\1/g' "$d/edit"
done

tr '\n' '+' < "$d/edit" | sed 's/+*$/\n/' | bc
