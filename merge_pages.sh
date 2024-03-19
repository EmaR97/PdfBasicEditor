#!/bin/bash

# Function for logging messages
log_message() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "$1"
    fi
}

# Function for logging error messages in red
error_message() {
    echo -e "\e[31mError: $1\e[0m" >&2
}
# Check if the correct number of arguments are provided
if [ $# -lt 1 ]; then
    error_message "No PDF file specified."
    echo "Usage: $0 <input_pdf> [-l]" >&2
    exit 1
fi

# Check if logging is enabled
if [ "$2" = "-l" ]; then
    LOG_ENABLED=true
else
    LOG_ENABLED=false
fi

# Input and output files
input_pdf="$1"

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
