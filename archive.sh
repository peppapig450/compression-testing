#!/bin/bash

set -Eeuo pipefail

file="$HOME/compression-testing/gcc.1"

if [[ ! -f "$file" ]]; then
	exit 1
fi

filesize() {
	du -h "$1" | cut -f -1
}

ogSize=$(filesize "$file")

gzp() {
	for f in gzip/{1..9}; do
		if [[ ! -d $f ]]; then
			echo "$f is not a directory" && local status='1'
		else
			local status=''
		fi
		if [[ $status = '1' ]]; then
			exit 1
		fi
	done
	for ((f = 1; f <= 9; f++)); do
		dest="$HOME/compression-testing/gzip/${f}/gcc.1.gz"
		gzip -"$f" -k "$file" -c >"$dest"
		echo "Original file size is $ogSize"
		echo "Compressed size with compresion level ""$f"" is $(filesize "$dest")"
	done
}
bzp() {
	for dir in bzip2/{1..9}; do
		if [[ ! -d $dir ]]; then
			echo "$dir is not a directory" && local status='1'
		else
			local status=''
		fi
		if [[ $status = '1' ]]; then
			exit 1
		fi
	done
	for ((f = 1; f <= 9; f++)); do
		dest="$HOME/compression-testing/bzip2/${f}/gcc.1.bz2"
		bzip2 -"$f" -k "$file" -c >"$dest"
		echo "Original file size is $ogSize"
		echo "Compressed size with compresion level ""$f"" is $(filesize "$dest")"
	done
}
bzp
