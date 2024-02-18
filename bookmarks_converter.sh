#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 input_file"
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    usage
    exit 1
fi

# Check if the input file exists
if [ ! -f "$1" ]; then
    echo "Error: Input file '$1' not found."
    exit 1
fi

# Define the output file name
output_file="${1%.*}_bookmarks.txt"

# Remove the output file if it already exists
if [ -f "$output_file" ]; then
    rm "$output_file" || { echo "Error: Unable to remove existing output file '$output_file'."; exit 1; }
fi

# Process the input file and generate bookmarks
while IFS= read -r line; do
    # Extract title and page number from the line
    title=$(echo "$line" | sed 's/.*- //;s/ (.*)//')
    page_number=$(echo "$line" | awk -F "Page " '{print $2}' | tr -d ')')

    # Count the indentation level
    indent_level=$(awk -F '-' '{print length($1)}' <<< "$line")

    # Write the bookmark entry to the output file
    cat >> "$output_file" <<EOF
BookmarkBegin
BookmarkTitle: $title
BookmarkLevel: $((indent_level / 4 + 1))
BookmarkPageNumber: $page_number
EOF

done < "$1"

# Check if the conversion is successful
if [ $? -eq 0 ]; then
    echo "Conversion completed. Bookmarks saved to '$output_file'."
else
    echo "Error: Conversion failed."
    exit 1
fi
