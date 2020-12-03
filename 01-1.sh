#!/bin/sh
for i in $(cat "$1"); do
	for j in $(cat "$1"); do
		if [ $(( i + j )) = 2020 ]; then
			echo $(( i * j ))
			exit
		fi
	done
done
