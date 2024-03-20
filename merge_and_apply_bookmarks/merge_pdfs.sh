#!/bin/bash

# Save current directory location
current_dir="$(pwd)"

# Change directory to the script's directory
cd "$(dirname "$0")" || exit

# Source common functions script
source ../utility_functions.sh "$@"

# Check if the folder parameter is provided
if [ $# -ne 1 ]; then
    error_message "Usage: $0 <pdf_folder>"
    exit 1
fi

# Set the directory containing the PDF files
pdf_directory="$1"

# Check if the input PDF file is not an absolute path
if [[ ! "$pdf_directory" = /* ]]; then
    # Prepend saved directory path to relative input PDF path
    pdf_directory="$current_dir/$pdf_directory"
fi

# Check if the directory exists
if [ ! -d "$pdf_directory" ]; then
    error_message "Directory '$pdf_directory' does not exist."
    exit 1
fi

# Create an array to hold the PDF files
pdf_files=()

# Iterate over each PDF file in the directory and add it to the array
for pdf_file in "$pdf_directory"/*.pdf; do
    pdf_files+=("$pdf_file")
done

# Use pdftk to concatenate all PDF files in the array into a single PDF
output_file="${pdf_directory}.pdf"
pdftk "${pdf_files[@]}" cat output "$output_file"

# Check if pdftk command executed successfully
if [ $? -ne 0 ]; then
    error_message "Failed to merge PDF files."
    exit 1
fi

log_message "PDF files have been merged into '$output_file'."
