# PDF Merger with Bookmarks

This set of scripts allows you to merge multiple PDF files into a single PDF and add bookmarks to each individual PDF within the merged document.

## Prerequisites

- Linux environment (the scripts are written in Bash).
- pdftk (PDF toolkit) installed. You can install it using your package manager (e.g., `apt install pdftk` for Debian-based systems).

## Usage

0. **Make the script executable**

    ```bash
    chmod +x merge_pdfs.sh  
    chmod +x create_bookmark_file.sh  
    chmod +x apply_bookmarks.sh  
    chmod +x merge_and_apply_bookmarks.sh  
    ```

1. **merge_pdfs.sh**: This script merges multiple PDF files into a single PDF.

    ```bash
    ./merge_pdfs.sh <pdf_folder>
    ```

   - `<pdf_folder>`: Path to the folder containing the PDF files you want to merge.


2. **create_bookmark_file.sh**: This script creates a bookmark file for the merged PDF.

    ```bash
    ./create_bookmark_file.sh <pdf_folder>
    ```

   - `<pdf_folder>`: Path to the folder containing the PDF files you want to merge.


3. **apply_bookmarks.sh**: This script applies the bookmark file to the merged PDF.

    ```bash
    ./apply_bookmarks.sh <pdf_folder>
    ```

   - `<pdf_folder>`: Path to the folder containing the PDF files you want to merge.


4. **merge_and_apply_bookmarks.sh**: This script calls all the above scripts in sequence.

    ```bash
    ./merge_and_apply_bookmarks.sh <pdf_folder>
    ```

   - `<pdf_folder>`: Path to the folder containing the PDF files you want to merge.


## Example

Suppose you have a folder named `pdf_files` containing several PDF files you want to merge. Here's how you can use the scripts:

1. Merge the PDF files:

    ```bash
    ./merge_pdfs.sh pdf_files
    ```

2. Create bookmarks for the merged PDF:

    ```bash
    ./create_bookmark_file.sh pdf_files
    ```

3. Apply the bookmarks to the merged PDF:

    ```bash
    ./apply_bookmarks.sh pdf_files
    ```

4. Alternatively, you can run all the steps in one go:

    ```bash
    ./merge_and_apply_bookmarks.sh pdf_files
    ```

## Notes

- Make sure to grant execute permissions to the scripts before running them. You can use the command `chmod +x <script_name.sh>` to make a script executable.
- Ensure that the folder containing the PDF files exists and contains the files you want to merge.
- The merged PDF file with bookmarks will be saved as `<pdf_folder>.TOC.pdf`.
- If you encounter any issues, make sure that `pdftk` is installed and available in your system's path.
