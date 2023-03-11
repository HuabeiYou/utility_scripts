#!/bin/bash

if [ $# -eq 0 ]; then
	echo "No input file specified"
	exit 1
fi

if [[ "$1" != *.md ]]; then
	echo "Input file must end with .md"
	exit 1
fi

input=$1
output=${input%.md}.pdf

pandoc \
	--from markdown \
	--pdf-engine xelatex \
	--listings \
	-V geometry:margin=1in \
	-V CJKmainfont="STSong" \
	-o "$output" "$input" # --template eisvogel \
