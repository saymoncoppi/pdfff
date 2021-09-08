# pdfff
<br/><br/><br/><br/>
<p align="center"><img src="https://raw.githubusercontent.com/saymoncoppi/pdfff/main/pdfff.png" height="30%" width="30%"></p>
<br/><br/><br/><br/>
A simple pdf font fix using Bash (linux/wsl) and Ghostscript. :) 
<br/><br/><br/><br/>

## Why
Sometimes the PDF generated doensn´t have embedded ttf fonts and you got issues when the file is sent to a printer. 
It causes a bad behavior due a fail in font substitution process if you´re using a system without the required font or specially when the host is an Android device.
So your hard copy will printed with a wrong font :(

## How it works
This script repair issues with (not)embedded fonts and also compress the file for re-distribution

### Base ghostscript command to embed fonts:
gs -o repaired.pdf -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress original.pdf

### Base ghostscript to embed and compress:
gs -q -o repaired.pdf -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/ebook -dAutoRotatePages=/None -dColorImageDownsampleType=/Bicubic -dColorImageResolution=72 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=72 -dMonoImageResolution=72 original.pdf

### Check your PDF file using pdffonts (requires poppler app)
$ pdffonts your_pdf.pdf
<br/><br/>
Results: \
![image](https://user-images.githubusercontent.com/22059715/132523702-ab05fa81-636c-4103-ad2b-61554e7ce8cf.png)
If the results has "no" on "emb column" and you are gettings ussies on your printing process, consider update the cidfmap and run pdfff to fix it.

### Update cidfmap
So if your file has a font that your host system doesn´t, you could add the entry bellow on /var/lib/ghostscript/fonts/cidfmap
<br/><br/>
"" /Arial  << /FileType /TrueType /Path (/usr/local/share/fonts/arial.ttf) /SubfontID 0 /CSI [(Identity) 0] >> ; ""

### Path and fonts
Path:
- If you´re using an installed font on your Microsoft Windows and running this script on WSL you could use "/mnt/c/Windows/Fonts/font.ttf" as a PATH
- If you want to point directly to ttf file, copy that to "/usr/local/share/fonts/font.ttf" and use it as a PATH
- You arelady got it!
Fonts:
- You could install Microsoft fonts yf you hasn´t, run "sudo apt install ttf-mscorefonts-installer"
- You could download Microsoft fonts from https://www.w7df.com/ and manually install





## Howto use pdfff
Get the script file, make it executable \
$ sudo chmod +x pdfff.sh \
Run \
$ ./pdfff.sh \

Sample PDFs to test if you have no one to start:
- https://www.learningcontainer.com/sample-pdf-files-for-testing/


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
