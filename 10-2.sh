#!/bin/sh
run() {
	two="0"
	one="0"
	zero="1"
	#printf "%d ->\t%d\t%d\t%d\n" "$1" "$two" "$one" "$zero" >&2
	while [ ! -z "$2" ]; do
		case "$(( $2 - $1 ))" in
		3)
			two="0"
			one="0"
			zero="$zero"
			;;
		2)
			two="$zero"
			zero="$(( one + zero ))"
			one="0"
			;;
		1)
			extra="$zero"
			zero="$(( two + one + zero ))"
			two="$one"
			one="$extra"
			;;
		esac
		#printf "%d ->\t%d\t%d\t%d\n" "$2" "$two" "$one" "$zero" >&2
		shift
	done
	echo "$zero"
}

run 0 $(sort -n "$3")
