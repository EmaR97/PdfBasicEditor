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

# Create the output PDF file with bookmarks
output_with_bookmarks="${pdf_directory}.TOC.pdf"

# Create the bookmark file
bookmark_file="${pdf_directory}.bmk.txt"

# Update the PDF file with the bookmark information
pdftk "${pdf_directory}.pdf" update_info "$bookmark_file" output "$output_with_bookmarks"

echo "Bookmarks have been added to ${pdf_directory}.pdf and saved as $output_with_bookmarks."

