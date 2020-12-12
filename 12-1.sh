#!/bin/sh
x=0
y=0
d=0
for command in $(cat "$3"); do
	letter="${command%%[0-9]*}"
	number="${command#[A-Z]}"
	case "$letter" in
	N) y="$(( y + number ))";;
	S) y="$(( y - number ))";;
	E) x="$(( x + number ))";;
	W) x="$(( x - number ))";;
	L) d="$(( (d + number + 360) % 360 ))";;
	R) d="$(( (d - number + 360) % 360 ))";;
	F)
		case "$d" in
		0) x="$(( x + number ))";;
		90) y="$(( y + number ))";;
		180) x="$(( x - number ))";;
		270) y="$(( y - number ))";;
		esac
		;;
	esac
done
echo "$(( (x >= 0 ? x : -x) + (y >= 0 ? y : -y) ))"
