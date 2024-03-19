```bash
sudo apt install texlive-latex-base
sudo apt install texlive-plain-generic
 ```

```bash
pdflatex numbers.tex
 ```

```bash
pdftk single_file.pdf multistamp numbers.pdf output single_document_numbered.pdf
 ```
