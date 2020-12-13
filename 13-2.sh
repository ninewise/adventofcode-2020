#!/bin/sh
eggd() {
	if [ "$2" -eq 0 ]; then
		true
	else
		echo "$(( $1 / $2 ))"
		eggd "$2" "$(($1 % $2))"
	fi
}

rggd() {
	a=1
	b=0
	for n in $(tac | sed 1d); do
		b_="$a"
		a="$(( b - (n * a) ))"
		b="$b_"
	done
	echo "$a"
}

n="$(sed '1d;s/,x//g;s/,/*/g;s/$/\n/' "$3" | bc)"
solution="$(sed 1d "$3" | tr ',' '\n' | cat -n | sed '/x/d;$s/$/\n/' | while read oi ni; do
#n=60
#{ echo 2 3; echo 3 4; echo 2 5; } | while read oi ni; do
	Ni="$(( n / ni ))"
	#printf "<$oi>" >&2
	oi="$(( (ni - oi + 1) % ni ))"
	#echo "<$(eggd "$ni" "$Ni" | rggd)><$oi>" >&2
	printf '((%d) * (%d) * (%d)) +' "$(eggd "$ni" "$Ni" | rggd)" "$Ni" "$oi"
done | sed 's/$/0\n/' | bc)"

if [ "$solution" -lt 0 ]; then
	solution="$(( (-solution / n + 1) * n + solution  ))"
fi
echo "$solution"
