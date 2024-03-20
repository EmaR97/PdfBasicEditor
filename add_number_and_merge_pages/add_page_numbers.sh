#!/bin/bash

# Save current directory location
current_dir="$(pwd)"

# Change directory to the script's directory
cd "$(dirname "$0")" || exit

# Source common functions script
source ../utility_functions.sh "$@"

# Function to extract size and number of pages of the input PDF using pdftk
extract_pdf_info() {
    pdftk "$1" dump_data | grep -oP "(?<=PageMediaDimensions: )(\d+ \d+)"
}

# Function to compile LaTeX document and generate PDF
compile_latex() {
    log_message "Compiling LaTeX document: $1"
    pdflatex "$1" > /dev/null 2>&1
    log_message "LaTeX document compiled successfully."
}

# Function to overlay empty pages onto the original PDF to add page numbers
overlay_pages() {
    log_message "Overlaying empty pages onto the original PDF..."
    pdftk "$1" multistamp "$2" output "$3"
    log_message "Empty pages overlaid successfully. New PDF with page numbers created: $3"
}

# Main script

# Check if the input PDF file argument is provided
if [ $# -lt 1 ]; then
    error_message "No PDF file specified."
    echo "Usage: $0 <input_pdf> [-l]"
    exit 1
fi

# Input PDF file
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

# Extract size and number of pages of the input PDF
log_message "Extracting size and number of pages of the input PDF..."
size=$(extract_pdf_info "$input_pdf")
num_pages=$(pdftk "$input_pdf" dump_data | grep -oP "(?<=NumberOfPages: )(\d+)")
log_message "Number of pages found in the PDF: $num_pages"

# Extract width and height from the size
width=$(echo $size | cut -d' ' -f1)
height=$(echo $size | cut -d' ' -f2)

# Create a new LaTeX document with correct size and number of pages
log_message "Creating a new LaTeX document with correct size and number of pages..."
cat << EOF > empty.tex
\documentclass[12pt]{article}
\usepackage{multido}
\usepackage[hmargin=.5cm,vmargin=1.5cm,paperwidth=${width}pt,paperheight=${height}pt]{geometry}
\usepackage{fancyhdr}

% Use a sans serif font for the entire document
\renewcommand{\familydefault}{\sfdefault}

% Define a new page style for the document
\fancypagestyle{myfancy}{
 \fancyhf{} % Clear header and footer
 \renewcommand{\headrulewidth}{0pt} % Remove header rule
 \fancyfoot[R]{\large\thepage} % Place page number in the bottom right corner with increased size
}

% Apply the custom page style to the document
\pagestyle{myfancy}

\begin{document}
 \multido{}{$num_pages}{\vphantom{x}\newpage} % Add empty pages with correct dimensions
\end{document}
EOF
log_message "LaTeX document created successfully."

# Compile the LaTeX document to generate the empty PDF
compile_latex empty.tex

# Overlay the empty pages onto the original PDF to add page numbers
overlay_pages "$input_pdf" empty.pdf "${input_pdf%.*}_numbered.pdf"

# Clean up temporary files
log_message "Cleaning up temporary files..."
rm -f empty.tex empty.aux empty.log empty.pdf
log_message "Temporary files cleaned up successfully."

log_message "Script execution completed."
