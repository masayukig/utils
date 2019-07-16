#!/bin/sh

for shorten_url in $1:
do
    curl -s -I ${shorten_url} | grep -i 'Location:' | cut -d' ' -f2 | tr -d '\r'
done

