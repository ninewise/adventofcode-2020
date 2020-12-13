#!/bin/sh
number="$(head -1 "$3")"
tr ',' '\n' < "$3" | sed '1d;/x/d;s/.*/print & - ('"$number"' % &), " * ", &, "\\n"/;$s/$/\n/' | bc | sort -n | head -1 | bc
