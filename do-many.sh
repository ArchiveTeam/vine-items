#!/bin/sh

find $SOURCE -iname 'vine-*_data.txt' | parallel -j8 ./do-one.sh {}
