# pdfff
A simple pdf font fix using Bash (linux/wsl) and Ghostscript. :)
<br />
<p align="center"><img src="https://raw.githubusercontent.com/saymoncoppi/pdfff/main/pdfff.png" height="30%" width="30%"></p>

## Why
Sometimes on PDF file generation some fonts aren´t embedded and you got issues when stream PDF data to a printer.
It causes a bad behavior due font substitution process if you´re using a system without the required font.
So your copy will print with a wrong font :(

## How it works
This script repair issues with (not)embedded fonts and also compress the file for re-distribution
Seems a bit silly I know but I hope you enjoy.

## Howto
Get the script file, make it executable
$ sudo chmod +x pdfff.sh \
Run \
$ ./pdfff.sh

EN and PT languages available \
$ ./pwapk.sh \

<div align="right">./pwapk.sh en OR ./pwapk.sh pt</div>

## References
- https://www.pdf2go.com/repair-pdf
- https://www.makeuseof.com/how-to-analyze-pdf-file-fonts/amp/
- https://superuser.com/questions/278562/how-can-i-fix-repair-a-corrupted-pdf-file
- https://stackoverflow.com/questions/15093661/cidfmap-on-ghostscript-8-64-substitute-cid-font-adobe-identity-is-not-provide
- https://gist.github.com/firstdoit/6390547#gistcomment-3467053
- https://www.learningcontainer.com/sample-pdf-files-for-testing/
- https://www.pdf-online.com/osa/optimize.aspx
- http://pdf-analyser.edpsciences.org/
- https://ghostscript.com/doc/9.26/Use.htm
- https://www.mankier.com/package/poppler-utils

## Todo
- Send your idea :P
