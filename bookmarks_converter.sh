#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' not found."
    exit 1
fi

# Create a new file to store the bookmarks
output_file="${1%.*}_bookmarks.txt"
touch "$output_file"

# Read input file line by line and convert to bookmarks
while IFS= read -r line; do
    # Extract title and page number from the line
    title=$(echo "$line" | sed 's/.*- //;s/    (Page.*//')
    page_number=$(echo "$line" | awk -F "Page " '{print $2}' | tr -d ')')

    # Count the indentation level
    indent_level=$(awk -F '-' '{print length($1)}' <<< "$line")

    # Write the bookmark entry to the output file
    echo "BookmarkBegin" >> "$output_file"
    echo "BookmarkTitle: $title" >> "$output_file"
    echo "BookmarkLevel: $((indent_level / 4 + 1))" >> "$output_file"
    echo "BookmarkPageNumber: $page_number" >> "$output_file"
done < "$1"

echo "Conversion completed. Bookmarks saved to '$output_file'."
