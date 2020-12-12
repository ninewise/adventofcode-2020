#!/bin/sh
x=0
y=0
dx=10
dy=1
for command in $(cat "$3"); do
	letter="${command%%[0-9]*}"
	number="${command#[A-Z]}"
	r=0
	case "$letter" in
	N) dy="$(( dy + number ))" ;;
	S) dy="$(( dy - number ))" ;;
	E) dx="$(( dx + number ))" ;;
	W) dx="$(( dx - number ))" ;;
	L) r="$number" ;;
	R) r="$(( 360 - number ))" ;;
	F) x="$(( (number * dx) + x ))" ;
	   y="$(( (number * dy) + y ))" ;;
	esac
	while [ "$r" -gt 0 ]; do
		nx="$(( -dy ))"
		dy="$dx"
		dx="$nx"
		r="$(( r  - 90 ))"
	done
	echo $x $y $dx $dy
done
echo "$(( (x >= 0 ? x : -x) + (y >= 0 ? y : -y) ))"
