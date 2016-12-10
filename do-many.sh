#!/bin/sh

if [ ! -n "${SOURCE+x}" ]; then
	echo '$SOURCE not set'
	exit 1
fi

if [ ! -n "${TARGET+x}" ]; then
	echo '$TARGET not set'
	exit 1
fi

find $SOURCE -iname 'vine-*_data.txt' | parallel -j8 ./do-one.sh {}
