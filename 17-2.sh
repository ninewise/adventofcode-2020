#!/bin/sh
d="$(mktemp -d)"
trap "rm -r '$d'" EXIT KILL

height="$(grep -c '.*' "$3")"
width="$(head -1 "$3" | tr -d '\n' | wc -c)"

mkdir "$d/a"
for y in $(seq "$height"); do
	for x in $(seq "$width"); do
		c="$(head -c1)"
		case "$c" in
		'#') touch "$d/a/$x,$y,0,0" ;;
		*) true ;;
		esac
	done
	head -c1 > /dev/null # newline
done < "$3"

minx="0"
maxx="$width"
miny="0"
maxy="$height"
minz="0"
maxz="0"
minw="0"
maxw="0"
for i in $(seq 6); do
	mkdir "$d/b"
	minx="$(( minx - 1 ))"
	maxx="$(( maxx + 1 ))"
	miny="$(( miny - 1 ))"
	maxy="$(( maxy + 1 ))"
	minz="$(( minz - 1 ))"
	maxz="$(( maxz + 1 ))"
	minw="$(( minw - 1 ))"
	maxw="$(( maxw + 1 ))"

	x="$minx"
	y="$miny"
	z="$minz"
	w="$minw"
	while [ "$x" -le "$maxx" ]; do
		while [ "$y" -le "$maxy" ]; do
			while [ "$z" -le "$maxz" ]; do
				while [ "$w" -le "$maxw" ]; do
					count=0
					for dx in -1 0 1; do
						for dy in -1 0 1; do
							for dz in -1 0 1; do
								for dw in -1 0 1; do
									if [ "$dx" -ne 0 -o "$dy" -ne 0 -o "$dz" -ne 0 -o "$dw" -ne 0 ]; then
										if [ -f "$d/a/$((x+dx)),$((y+dy)),$((z+dz)),$((w+dw))" ]; then
											count="$(( count + 1 ))"
										fi
									fi
								done
							done
						done
					done
					if [ -f "$d/a/$x,$y,$z,$w" ]; then
						if [ '(' "$count" -eq 2 -o "$count" -eq 3 ')' ]; then
							touch "$d/b/$x,$y,$z,$w"
						fi
					elif [ "$count" -eq 3 ]; then
						touch "$d/b/$x,$y,$z,$w"
					fi
					w="$(( w + 1 ))"
				done
				z="$(( z + 1 ))"
				w="$minw"
			done
			y="$(( y + 1 ))"
			z="$minz"
		done
		x="$(( x + 1 ))"
		y="$miny"
	done

	rm -r "$d/a"
	mv "$d/b" "$d/a"
done

ls "$d/a" | wc -l
