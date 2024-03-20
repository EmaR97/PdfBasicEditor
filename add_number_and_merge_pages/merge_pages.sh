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
    echo "Usage: $0 <input_pdf> [-l]" >&2
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

 # Constructing the output filename based on input filename

output_file="${input_pdf%.*}_dual.pdf"
# Generate PDF with two pages per sheet
pdfjam "$input_pdf" -o "$output_file" --nup 1x2 > /dev/null 2>&1

if [ $? -eq 0 ]; then
log_message "PDF with two pages per sheet generated: $output_file"
else
    error_message "Failed to generate PDF with two pages per sheet."
fi
