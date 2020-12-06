#!/bin/sh
fill() {
	printf 'a\nb\nc\nd\ne\nf\ng\nh\ni\nj\nk\nl\nn\nm\no\np\nq\nr\ns\nt\nu\nv\nw\nx\ny\nz\n' > "$1"
}
{
	f="$(mktemp)"
	fill "$f"
	while read -r line || [ ! -z "$line" ]; do
		case "$line" in
		"") printf '%d + ' "$(wc -l < "$f")"; fill "$f" ;;
		*)  printf '%s' "$line" | sed 's/./&\n/g' | cat - "$f" | sort | uniq -d | sponge "$f" ;;
		esac
	done < "$3"
	wc -l < "$f"
} | bc
