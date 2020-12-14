#!/bin/sh
bin2dec() {
	n=0
	while c="$(head -c 1)" && [ ! -z "$c" ]; do
		case "$c" in
		0) n="$(( (n << 1) ))" ;;
		1) n="$(( (n << 1) + 1 ))" ;;
		*) echo "$n" && n=0 ;;
		esac
	done
	echo "$n"
}

mask1="0"
mask0="0"
while read -r line || [ ! -z "$line" ]; do
	# remove masks
	case "$line" in
	mask*)
		mask1="$(echo "${line##* }" | tr 'X' '0' | bin2dec)"
		mask0="$(echo "${line##* }" | tr 'X' '1' | bin2dec)"
		;;
	mem*)
		number="${line##* }"
		printf '%s = %d\n' "${line%% *}" "$(( (number | mask1) & mask0 ))"
		;;
	esac
done < "$3" | sed 's/mem.//;s/. = / /' | sort -n -s | {
	read -r previouslocation previousvalue
	while read -r location value; do
		if [ "$location" -ne "$previouslocation" ]; then
			echo "$previousvalue"
		fi
		previouslocation="$location"
		previousvalue="$value"
	done
	echo "$previousvalue"
} | tr '\n' '+' | sed 's/$/0\n/' | bc
