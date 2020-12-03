#!/bin/sh
for i in $(cat "$1"); do
	for j in $(cat "$1"); do
		for k in $(cat "$1"); do
			if [ $(( i + j + k )) = 2020 ]; then
				echo $(( i * j * k ))
				exit
			fi
		done
	done
done
