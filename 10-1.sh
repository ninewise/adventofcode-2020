#!/bin/sh
previous=0
ones=0
threes=0
for joltage in $(sort -n "$3"); do
	case "$(( joltage - previous ))" in
	1) ones="$(( ones + 1 ))" ;;
	3) threes="$(( threes + 1 ))" ;;
	*) true ;;
	esac
	previous="$joltage"
done
printf "%d * %d = %d\n" "$ones" "$(( threes + 1 ))" "$(( (threes + 1) * ones ))"
