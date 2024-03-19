#!/bin/bash

# Extract size and number of pages of the input PDF using pdftk
size=$(pdftk single_file.pdf dump_data | grep -oP "(?<=PageMediaDimensions: )(\d+ \d+)")
num_pages=$(pdftk single_file.pdf dump_data | grep -oP "(?<=NumberOfPages: )(\d+)")

# Print the number of pages found in the PDF
echo "Number of pages found in the PDF: $num_pages"

# Extract width and height from the size
width=$(echo $size | cut -d' ' -f1)
height=$(echo $size | cut -d' ' -f2)

# Create a new LaTeX document with correct size and number of pages
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
 \multido{}{${num_pages}}{\vphantom{x}\newpage} % Add empty pages with correct dimensions
\end{document}
EOF

# Compile the LaTeX document to generate the empty PDF
pdflatex empty.tex

# Overlay the empty pages onto the original PDF to add page numbers
pdftk single_file.pdf multistamp empty.pdf output single_document_numbered.pdf

# Clean up temporary files
rm empty.tex empty.aux empty.log empty.pdf
