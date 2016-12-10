#!/bin/sh

echo $1
lua process.lua $1 | curl -u "$CREDENTIALS" -H 'Content-Type: application/json' -X POST -s --data-binary @- http://localhost:5984/vine/_bulk_docs > /dev/null
mv $1 $TARGET
