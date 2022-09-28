#!/usr/bin/env bash

EXCLUDE_LIST="exclude.txt"

DIFF_EXCLUDE=""

while IFS= read -r line; do
    DIFF_EXCLUDE+=" ':(exclude)$line'"
done < "$EXCLUDE_LIST"

export LIST=$DIFF_EXCLUDE
