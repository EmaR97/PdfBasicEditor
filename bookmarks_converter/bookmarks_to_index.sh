#!/bin/bash

# Source common functions script
source ../utility_functions.sh

# Call the check_log_option function with all command-line arguments
check_log_option "$@"

# Function to display usage information
usage() {
    echo "Usage: $0 input_file"
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 1 ]; then
    usage
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    error_message "Input file '$1' not found."
    exit 1
fi

output_file="${1%.*}.idx.txt"

# Remove the output file if it already exists
if [ -f "$output_file" ]; then
    rm "$output_file" || { error_message "Unable to remove existing output file '$output_file'."; exit 1; }
fi

# Read the input file line by line
while IFS= read -r line; do
    if [[ $line =~ ^BookmarkTitle:\ (.*) ]]; then
        title="${BASH_REMATCH[1]}"
    elif [[ $line =~ ^BookmarkLevel:\ ([0-9]+) ]]; then
        level="${BASH_REMATCH[1]}"
        indentation=""
        for ((i = 1; i < level; i++)); do
            indentation+="    "
        done
    elif [[ $line =~ ^BookmarkPageNumber:\ ([0-9]+) ]]; then
            page="${BASH_REMATCH[1]}"
            echo "$indentation$title (Page $page)"
    fi
done < "$1" > "$output_file"

# Check if the conversion is successful
if [ $? -eq 0 ]; then
    log_message "Conversion completed. Index saved to '$output_file'."
else
    error_message "Conversion failed."
    exit 1
fi
