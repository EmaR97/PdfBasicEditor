#!/bin/bash

# Save current directory location
current_dir="$(pwd)"

# Change directory to the script's directory
cd "$(dirname "$0")" || exit

# Source common functions script
source ../utility_functions.sh "$@"

# Check if the correct number of arguments are provided
if [ $# -lt 1 ]; then
    error_message "No PDF file specified."
    echo "Usage: $0 <input_pdf> [-l]"
    exit 1
fi

# Input and output files
input_pdf="$1"

# Check if the input PDF file is not an absolute path
if [[ ! "$input_pdf" = /* ]]; then
    # Prepend saved directory path to relative input PDF path
    input_pdf="$current_dir/$input_pdf"
fi

# Check if the input PDF file exists
if [ ! -f "$input_pdf" ]; then
    error_message "Input PDF file '$input_pdf' not found."
    exit 1
fi

log_message "Input PDF file found: $input_pdf"


# Call merge_pdfs.sh script
if [ "$LOG_ENABLED" = true ]; then
  ./add_page_numbers.sh "$input_pdf" -l
fi
./add_page_numbers.sh "$input_pdf"

first_output_file="${input_pdf%.*}_numbered.pdf"

# Call create_bookmark_file.sh script
if [ "$LOG_ENABLED" = true ]; then
  ./merge_pages.sh "$first_output_file" -l
fi
./merge_pages.sh "$first_output_file"

rm -f "$first_output_file"
log_message "Merge and apply bookmarks process completed."

