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

# Input PDF file
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

# Call merge_pdfs.sh script
./merge_pdfs.sh "$pdf_directory"

# Check if merge_pdfs.sh script executed successfully
if [ $? -ne 0 ]; then
    error_message "Failed to merge PDF files."
    exit 1
fi

log_message "PDF files have been merged successfully."

# Call create_bookmark_file.sh script
./create_bookmark_file.sh "$pdf_directory"

# Check if create_bookmark_file.sh script executed successfully
if [ $? -ne 0 ]; then
    error_message "Failed to create bookmark file."
    exit 1
fi

log_message "Bookmark file has been created successfully."

# Call apply_bookmarks.sh script
./apply_bookmarks.sh "$pdf_directory.pdf"

# Check if apply_bookmarks.sh script executed successfully
if [ $? -ne 0 ]; then
    error_message "Failed to apply bookmarks."
    exit 1
fi

log_message "Bookmarks have been applied successfully."

log_message "Merge and apply bookmarks process completed."

