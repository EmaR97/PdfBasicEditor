#!/bin/bash

# Function for logging messages
log_message() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "$1"
    fi
}

# Function for logging error messages in red
error_message() {
    echo -e "\e[31mError: $1\e[0m"
}
# Check if the correct number of arguments are provided
if [ $# -lt 1 ]; then
    error_message "No PDF file specified."
    echo "Usage: $0 <input_pdf> [-l]"
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

