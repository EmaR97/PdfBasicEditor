#!/bin/bash

# Save current directory location
current_dir="$(pwd)"

# Change directory to the script's directory
cd "$(dirname "$0")" || exit

# Source common functions script
source ../utility_functions.sh "$@"

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

input="$1"

# Check if the input PDF file is not an absolute path
if [[ ! "$input" = /* ]]; then
    # Prepend saved directory path to relative input PDF path
    input="$current_dir/$input"
fi

# Check if the input file exists
if [ ! -f "$input" ]; then
    error_message "Input file '$input' not found."
    exit 1
fi

# Define the output file name
output_file="${$input%.*}.bmk.txt"

# Remove the output file if it already exists
if [ -f "$output_file" ]; then
    rm "$output_file" || { error_message "Unable to remove existing output file '$output_file'."; exit 1; }
fi

# Process the input file and generate bookmarks
while IFS= read -r line; do

    # Extract title and page number from the line
    title=$(echo "$line" | sed -E 's/^[[:space:]]*//;s/ \(Page [0-9]+\)$//')
    page_number=$(echo "$line" | awk -F "Page " '{print $2}' | tr -d ')')

    # Count the indentation level
    indent_level=$(expr "$line" : '^[[:space:]]*')
    indent_level=$((indent_level/4+1))
    # Write the bookmark entry to the output file
    cat >> "$output_file" <<EOF
BookmarkBegin
BookmarkTitle: $title
BookmarkLevel: $((indent_level))
BookmarkPageNumber: $page_number
EOF

done < "$1"

# Check if the conversion is successful
if [ $? -eq 0 ]; then
    log_message "Conversion completed. Bookmarks saved to '$output_file'."
else
    error_message "Conversion failed."
    exit 1
fi
