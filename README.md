# PDF Merger with Bookmarks and Page Numbering

This set of scripts allows you to merge multiple PDF files into a single PDF, add bookmarks to each individual PDF
within the merged document, and add page numbers to the merged PDF.

## Prerequisites

- Linux environment (the scripts are written in Bash).
- **Install pdftk** (PDF toolkit). You can install it using your package manager (e.g., `apt install pdftk` for
  Debian-based systems).
  ```bash
  sudo apt install -y pdftk
  ```
- **Install TeX Live** for LaTeX compilation. You can install it using your package manager (
  e.g., `apt install texlive texlive-latex-base texlive-plain-generic` for Debian-based systems).
  ```bash
  sudo apt install -y texlive texlive-latex-base texlive-plain-generic
  ```
- **Make the scripts executable**
   ```bash
   chmod +x add_number_and_merge_pages/add_page_numbers.sh
   chmod +x add_number_and_merge_pages/merge_pages.sh
   chmod +x add_number_and_merge_pages/complete.sh 
   ```
     ```bash
   chmod +x bookmarks_converter/bookmarks_to_index.sh
   chmod +x bookmarks_converter/index_to_bookmarks.sh
   ```
     ```bash
   chmod +x merge_and_apply_bookmarks/merge_pdfs.sh  
   chmod +x merge_and_apply_bookmarks/create_bookmark_file.sh  
   chmod +x merge_and_apply_bookmarks/apply_bookmarks.sh  
   chmod +x merge_and_apply_bookmarks/complete.sh  
   ```

## Usage

- **add_page_numbers.sh**: This script adds page numbers to the PDF.
    ```bash
    ./add_page_numbers.sh <input_pdf>
    ```
- **merge_pdfs.sh**: This script merges multiple PDF files into a single PDF.
    ```bash
    ./merge_pdfs.sh <pdf_folder>
    ```
    - `<pdf_folder>`: Path to the folder containing the PDF files you want to merge.
- **create_bookmark_file.sh**: This script creates a bookmark file for the merged PDF.

    ```bash
    ./create_bookmark_file.sh <pdf_folder>
    ```
- **apply_bookmarks.sh**: This script applies the bookmark file to the merged PDF.

    ```bash
    ./apply_bookmarks.sh <pdf_folder>
    ```
- **merge_and_apply_bookmarks.sh**: This script merges PDF files, creates bookmarks, and applies them to the merged PDF.
    ```bash
    ./complete.sh <pdf_folder>
    ```

## Notes

- Make sure to grant execute permissions to the scripts before running them. You can use the
  command `chmod +x <script_name.sh>` to make a script executable.
- Ensure that the folder containing the PDF files exists and contains the files you want to merge.
- The merged PDF file with bookmarks will be saved as `<pdf_folder>.TOC.pdf`.
- If you encounter any issues, make sure that `pdftk` and `texlive` are installed and available in your system's path.