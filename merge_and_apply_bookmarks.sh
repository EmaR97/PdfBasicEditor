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

# Call merge_pdfs.sh script
./merge_pdfs.sh "$pdf_directory"

# Call create_bookmark_file.sh script
./create_bookmark_file.sh "$pdf_directory"

# Call apply_bookmarks.sh script
./apply_bookmarks.sh "$pdf_directory"

echo "Merge and apply bookmarks process completed."

