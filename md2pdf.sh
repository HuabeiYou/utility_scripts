#!/bin/bash

usage() {
	echo "Usage: $0 input_file.md [-l|--lang language]"
	exit 1
}

check_input_file() {
	echo $1
	if [[ "$1" != *.md ]]; then
		echo "Input file must end with .md"
		usage
		exit 1
	fi
}

# --template eisvogel
process_args() {
	while [[ $# -gt 0 ]]; do
		key="$1"
		case $key in
		-l | --lang)
			lang="$2"
			shift 2
			;;
		*)
			shift
			;;
		esac
	done

	# Set default value for lang if not specified
	if [ -z "$lang" ]; then
		lang="en"
	fi
}

construct_cmd() {
	# if [ "$lang" = "cn" ] || [ "$lang" = "chinese" ]; then
	# 	cmd="pandoc --from markdown --pdf-engine xelatex --template eisvogel -V CJKmainfont=\'Noto Sans CJK SC\' $input -o $output"
	# else
	# 	cmd="pandoc --from markdown --pdf-engine xelatex --template eisvogel $input -o $output"
	# fi
	cmd="pandoc --from markdown --pdf-engine xelatex --template eisvogel --highlight-style tango -V CJKmainfont=\"Hei\" $input -o $output"
}

if [ $# -eq 0 ]; then
	usage
fi

input="$1"
check_input_file "$input"
output="${input%.md}.pdf"

process_args "$@"
construct_cmd

eval "$cmd"
