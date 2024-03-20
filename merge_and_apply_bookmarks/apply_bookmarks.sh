#!/bin/bash

# Save current directory location
current_dir="$(pwd)"

# Change directory to the script's directory
cd "$(dirname "$0")" || exit

# Source common functions script
source ../utility_functions.sh "$@"

# Check if the folder parameter is provided
if [ $# -ne 1 ]; then
    error_message "Usage: $0 <pdf_file>"
    exit 1
fi

# Set the directory containing the PDF files
pdf_file="$1"

# Check if the input PDF file is not an absolute path
if [[ ! "$pdf_file" = /* ]]; then
    # Prepend saved directory path to relative input PDF path
    pdf_file="$current_dir/$pdf_file"
fi
# Check if the input file exists
if [ ! -f "$pdf_file" ]; then
    error_message "Input file '$pdf_file' not found."
    exit 1
fi

# Create the output PDF file with bookmarks
output_with_bookmarks="${pdf_file%.*}.TOC.pdf"

# Create the bookmark file
bookmark_file="${pdf_file%.*}.bmk.txt"

# Update the PDF file with the bookmark information
pdftk "$pdf_file" update_info "$bookmark_file" output "$output_with_bookmarks"

log_message "Bookmarks have been added to $pdf_file and saved as $output_with_bookmarks."
