#!/bin/sh
for i in $(cat 01-input); do
	for j in $(cat 01-input); do
		if [ $(( i + j )) = 2020 ]; then
			echo $(( i * j ))
			exit
		fi
	done
done
