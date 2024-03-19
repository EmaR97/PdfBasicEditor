#!/bin/bash

# Check if the folder parameter is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <pdf_folder>"
    exit 1
fi

# Set the directory containing the PDF files
pdf_directory="$1"

# Check if the directory exists
if [ ! -d "$pdf_directory" ]; then
    echo "Error: Directory '$pdf_directory' does not exist."
    exit 1
fi

# Initialize a variable to keep track of the total page count
total_pages=0

# Create a temporary file to store the bookmark information
bookmark_file="${pdf_directory}.bmk.txt"
pdftk "${pdf_directory}.pdf" dump_data output "$bookmark_file"               

# Iterate over each PDF file in the directory
for pdf_file in "$pdf_directory"/*.pdf; do
    # Get the filename without the extension
    filename=$(basename -- "$pdf_file")
    filename_no_extension="${filename%.*}"

    # Remove date prefix if it exists in the filename
    filename_no_date="${filename_no_extension#[0-9][0-9][0-9][0-9][0-1][0-9][0-3][0-9]_}"

    # Use pdftk to get the number of pages
    num_pages=$(pdftk "$pdf_file" dump_data | grep NumberOfPages | awk '{print $2}')

    # Print the output in the desired format
    echo "BookmarkBegin" >> "$bookmark_file"
    echo "BookmarkTitle: $filename_no_date" >> "$bookmark_file"
    echo "BookmarkLevel: 1" >> "$bookmark_file"
    echo "BookmarkPageNumber: $((total_pages + 1))" >> "$bookmark_file"

    # Update the total page count
    total_pages=$((total_pages + num_pages))
done

echo "Bookmarks have been created and saved in $bookmark_file."

