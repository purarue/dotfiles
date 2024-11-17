#!/usr/bin/env bash
# ranger supports enhanced previews.  If the option "use_preview_script"
# is set to True and this file exists, this script will be called and its
# output is displayed in ranger.  ANSI color codes are supported.

# NOTES: This script is considered a configuration file.  If you upgrade
# ranger, it will be left untouched. (You must update it yourself.)
# Also, ranger disables STDIN here, so interactive scripts won't work properly

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | success. display stdout as preview
# 1    | no preview | failure. display no preview at all
# 2    | plain text | display the plain content of the file
# 3    | fix width  | success. Don't reload when width changes
# 4    | fix height | success. Don't reload when height changes
# 5    | fix both   | success. Don't ever reload
# 6    | image      | success. display the image $cached points to as an image preview
# 7    | image      | success. display the file directly as an image

# shellcheck disable=SC2317

# Meaningful aliases for arguments:
path="$1" # Full path of the selected file
#width="$2"           # Width of the preview pane (number of fitting characters)
height="$3"         # Height of the preview pane (number of fitting characters)
cached="$4"         # Path that should be used to cache image previews
preview_images="$5" # "True" if image previews are enabled, "False" otherwise.

maxln=$((height * 3))

# Find out something about the file:
mimetype=$(file --mime-type -Lb "$path")

# Functions:
# runs a command and saves its output into $output.  Useful if you need
# the return value AND want to use the output in a pipe
try() { output=$(eval '"$@"'); }

# writes the output of the previously used "try" command
dump() { head -n "$maxln" <<<"$output"; }

# wraps highlight to treat exit code 141 (killed by SIGPIPE) as success
safepipe() {
	"$@"
	test $? = 0 -o $? = 141
}

# Image previews, if enabled in ranger.
if [ "$preview_images" = "True" ]; then
	case "$mimetype" in
	image/gif)
		# my script to get the middle frame of a gif
		cp "$(gifpreview "$path")" "$cached" && exit 6 || exit 1
		;;
	image/svg+xml)
		convert "$path" "$cached" && exit 6 || exit 1
		;;
	image/x-fuji-raf)
		# remove extension and replace with 'JPG', try to preview
		maybe_jpg="${path%.*}.JPG"
		if [[ -f "$maybe_jpg" ]]; then
			cp "$maybe_jpg" "$cached" && exit 6 || exit 1
		else
			pistol_or_exifinfo
		fi
		;;
	image/*)
		exit 7
		;;
		# Image preview for video, disabled by default.:
	video/*)
		ffmpegthumbnailer -i "$path" -o "$cached" -s 0 && exit 6 || exit 1
		;;
	esac
fi

case "$mimetype" in
# Display information about media files:
video/* | audio/*)
	exifinfo "$path" && exit 0
	;;
# Syntax highlight for text files:
# For json files that dont end with *.json
# (wouldn't be recognized by highlight or pistol)
application/json)
	try safepipe print-json "$path" && {
		dump
		exit 5
	}
	;;
application/csv)
	try head -n$((maxln * 2)) "$path" && {
		dump
		exit 5
	}
	;;
application/x-sharedlib | application/x-executable | application/x-pie-executable)
	exifinfo "$path" && exit 0
	;;
application/zip)
	try unzip -Z1 "$path" && {
		dump
		exit 5
	}
	;;
application/gzip)
	try tar -tzf "$path" && {
		dump
		exit 5
	}
	;;
*)
	case "$path" in
	*.zip)
		try unzip -Z1 "$path" && {
			dump
			exit 5
		}
		;;
	# Python pickled objects
	*.pickle)
		# printing pickled data in preview
		# window doesn't look good. can use
		# rifle to preview it by running the file
		echo "Pickled Python Data"
		exifinfo "$path"
		exit 5
		;;
	# PDF documents:
	*.pdf)
		try pdftoppm -jpeg -singlefile "$path" "${cached//.jpg/}" && exit 6 || exit 1
		;;
	*.docx)
		try pandoc -t markdown "$path" && {
			dump
			exit 5
		}
		;;
	*.1)
		try safepipe man -P cat "$path" && {
			dump
			exit 0
		}
		;;
	esac
	try safepipe highlight --out-format=ansi "$path" && {
		dump
		exit 5
	}
	;;
esac

pistol_or_exifinfo() {
	# if pistol takes way too long (0.3s) to calculate this
	# its probably a huge textfile and its having issues determining
	# how to preview it
	if try timeout 0.3 pistol "$path"; then
		dump
		exit 5
	else
		# default to just showing some metadata about the file
		exifinfo "$path"
		exit 5
	fi
}

pistol_or_exifinfo
exit 1
