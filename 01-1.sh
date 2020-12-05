#!/bin/sh
for i in $(cat "$3"); do
	for j in $(cat "$3"); do
		if [ $(( i + j )) = 2020 ]; then
			echo $(( i * j ))
			exit
		fi
	done
done
