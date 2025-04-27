#!/bin/bash

# -- Help option
if [[ "$1" == "--help" ]]; then
    echo "Usage: ./mygrep.sh [-n] [-v] search_string filename"
    echo ""
    echo "Options:"
    echo "  -n    Show line numbers for matches"
    echo "  -v    Invert match (show lines that do NOT match)"
    exit 0
fi

# -- Check minimum arguments
if [[ $# -lt 2 ]]; then
    echo "Error: Missing search string or filename."
    echo "Usage: ./mygrep.sh [options] search_string filename"
    exit 1
fi

# -- Initialize flags
show_line_numbers=false
invert_match=false

# -- Option parsing
while [[ "$1" == -* ]]; do
    case "$1" in
        -n) show_line_numbers=true ;;
        -v) invert_match=true ;;
        -vn|-nv) show_line_numbers=true; invert_match=true ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
    shift
done

# -- Assign search string and file
search_string="$1"
file="$2"

# -- Check file exists
if [[ -z "$search_string" || -z "$file" ]]; then
    echo "Error: Missing search string or file."
    echo "Usage: ./mygrep.sh [-n] [-v] search_string filename"
    read -p "Press ENTER to exit"
    exit 1
fi

if [[ ! -f "$file" ]]; then
    echo "Error: File '$file' not found."
    exit 1
fi

# -- Main logic
line_number=0

while IFS= read -r line; do
    ((line_number++))

    # Check if line matches (case-insensitive)
    if echo "$line" | grep -iq "$search_string"; then
        match=true
    else
        match=false
    fi

    # Decide to print line
    should_print=false
    if $match && ! $invert_match; then
        should_print=true
    elif ! $match && $invert_match; then
        should_print=true
    fi

    if $should_print; then
        if $show_line_numbers; then
            echo "${line_number}:$line"
        else
            echo "$line"
        fi
    fi

done < "$file"

read -p "Press ENTER to exit"
