#!/bin/sh
for i in $(cat 01-input); do
	for j in $(cat 01-input); do
		for k in $(cat 01-input); do
			if [ $(( i + j + k )) = 2020 ]; then
				echo $(( i * j * k ))
				exit
			fi
		done
	done
done
