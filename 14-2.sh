#!/bin/sh
bin2dec() {
	tr '\n' '_' | {
		n=0
		while c="$(head -c 1)" && [ "$c" != "" ]; do
			case "$c" in
			0) n="$(( (n << 1) ))" ;;
			1) n="$(( (n << 1) + 1 ))" ;;
			_) echo "$n" && n=0 ;;
			esac
		done
	}
}

f="$(mktemp)"
mask1=0
while read -r line || [ ! -z "$line" ]; do
	# remove masks
	case "$line" in
	mask*)
		mask1="$(echo "${line##* }" | tr 'X' '1' | bin2dec)"
		echo "${line##* }" | tr '1' '0' > "$f"
		while grep -q X "$f"; do
			sed -i '/X/{h;s/X/0/p;g;s/X/1/}' "$f"
		done
		bin2dec < "$f" | sponge "$f"
		;;
	mem*)
		address="${line#*[}"
		address="${address%%]*}"
		address="$(( address | mask1 ))"
		echo "<$address>" >&2
		number="${line##* }"
		for mask in $(cat "$f"); do printf '%d %d\n' "$(( address ^ mask ))" "$number"; done
		;;
	esac
done < "$3" | sort -n -s | {
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
rm "$f"
