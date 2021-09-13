#!/usr/bin/env bash
#
# About: 
# A simple PDF font fix
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Global variables
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------

last_update='20210913'

# Color Settings
c1='\e[38;5;235m'       # Dark Grey
c2='\e[38;5;237m'       # Light Grey
c3='\e[0m'              # White
c4='\e[38;5;132m'       # Messages
menu=`echo "\033[m"` #old color `echo "\033[36m"`
number=`echo "\033[33m"` #yellow
bgred=`echo "\033[41m"`
fgred=`echo "\033[31m"`
msgcolor=`echo "\033[01;31m"` # bold red
normal=`echo "\033[00;00m"` # normal white

#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Translation session
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------

#Default language
get_language=$1
case $get_language in
"en")lang=0;;
"pt")lang=1;;
"es")lang=2;;
esac


# Translations EN=0, PT=1 and ES=2 
# sample_desc=('Missing_EN_Translation' 'Missing_PT_Translation ' 'Missing_ES_Translation ')

# Splash texts
splash_text1=('A simple pdf font fix using Bash' 'Um simples pdf font fix usando Bash' 'Missing_ES_Translation ')
splash_text2=('(linux/wsl) and Ghostscript. :)' '(linux/wsl) e Ghostscript. :)' 'Missing_ES_Translation ')

#font fix texts
fontfix_text1=('Checking INPUT folder:' 'Verificando pasta INPUT:' 'Missing_ES_Translation ')
fontfix_text2=('Repaired/Compressed' 'Reparado/Comprimido' 'Missing_ES_Translation ')
fontfix_text3=('Files not Found!' 'Nenhum arquivo encontrado!' 'Missing_ES_Translation ')
fontfix_text4=('Original:' 'Original:' 'Missing_ES_Translation ')
fontfix_text5=('New:' 'Novo:' 'Missing_ES_Translation ')
fontfix_text6=('Compression:' 'Compressão:' 'Missing_ES_Translation ')
fontfix_text7=('Files converted: ' 'Arquivos convertidos: ' 'Missing_ES_Translation ')

#font fix texts
check_env_text1=('Ops! You have to run' 'Ops! Você deve executar' 'Missing_ES_Translation ')

#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Folders
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
# Dont use folders with SPACE
INPUT="input/"
OUTPUT="converted/"
BACKUP="bkp/"
LOG="logs/"



#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Font Fix
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------


function font_fix (){
    # Ghostscript Settings

    sDEVICE="pdfwrite" # pdfwrite device outputs a PDF file

    dPDFSETTINGS="/ebook"
    # /screen selects low-resolution output similar to the Acrobat Distiller (up to version X) "Screen Optimized" setting.
    # /ebook selects medium-resolution output similar to the Acrobat Distiller (up to version X) "eBook" setting.
    # /printer selects output similar to the Acrobat Distiller "Print Optimized" (up to version X) setting.
    # /prepress selects output similar to Acrobat Distiller "Prepress Optimized" (up to version X) setting.
    # /default selects output intended to be useful across a wide variety of uses, possibly at the expense of a larger output file.

    dAutoRotatePages="/None"

    dColorImageDownsampleType="/Bicubic"
    dGrayImageDownsampleType="/Bicubic"

    pdf_resolution="72"                     # 72 is used to decrease the file size
    dColorImageResolution=$pdf_resolution
    dGrayImageResolution=$pdf_resolution
    dMonoImageResolution=$pdf_resolution

    # Documment properties
    pdf_author="author"                     # Fill here if you want
    pdf_producer="pdfff"                    # Fill here if you want
    pdf_subject="pdfff repaired file"       # Fill here if you want



    echo ${fontfix_text1[$lang]}
    echo "------------------------------------------------------------------------------------------------------------------------"
    files_converted=0
    for i in "${input_folder[@]}"; do 
        current_file=$(echo "${i}" | awk -F/ '{print $2}')
        current_title=$(basename -- "${current_file}" .pdf)
     
        echo -ne "${current_file}   -   ${c4}${fontfix_text2[$lang]}${normal}   -   "
        
        gs -q -o "${OUTPUT}/${current_file}" \
        -sDEVICE=$sDEVICE \
        -dPDFSETTINGS=$dPDFSETTINGS \
        -dAutoRotatePages=$dAutoRotatePages \
        -dColorImageDownsampleType=$dColorImageDownsampleType \
        -dColorImageResolution=$dColorImageResolution \
        -dGrayImageDownsampleType=$dGrayImageDownsampleType \
        -dGrayImageResolution=$dGrayImageResolution \
        -dMonoImageResolution=$dMonoImageResolution \
        "input/${current_file}" \
        -c "[ /Title (${current_title}) \
        /Author (${pdf_author}) \
        /Producer (${pdf_producer}) \
        /Subject (${pdf_subject})
        /DOCINFO pdfmark" \ -f

        original_size=$(wc -c "${INPUT}${current_file}" | awk '{print $1}')
        post_size=$(wc -c "${OUTPUT}${current_file}" | awk '{print $1}')
        compression_ratio=$(echo "scale=4 ; (($post_size-$original_size)/$original_size)*100" | bc | awk -F. '{print $1}')
        echo -ne "${fontfix_text4[$lang]}${c4}${original_size} ${normal}${fontfix_text5[$lang]}${c4}$post_size ${normal}${fontfix_text6[$lang]}${c4}$compression_ratio%${normal}\n"

        echo -e "$(date '+%Y%m%d%H%M%S');$current_file, $original_size, $post_size, $compression_ratio"  |& tee >> "$LOG/$OUTPUTFILE"

        mv "${INPUT}${current_file}" "${BACKUP}${current_file}"

        files_converted=`expr $files_converted + 1`
    done
    echo -ne "\n${fontfix_text7[$lang]}${c4}$files_converted\n"
}



#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Check Env
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------


function check_env (){
    #check for required packages
    for pkg in poppler-utils ghostscript; do
        if [ $(dpkg-query -W -f='${Status}' $pkg 2>/dev/null | grep -c "ok installed") -eq 0 ];then
            echo -ne "${normal}${check_env_text1[$lang]}${c4} sudo apt install $pkg${normal}\n"
            exit 1
        fi		
    done

    #check folders
	for folder in $INPUT $BACKUP $OUTPUT $LOG; do
		[[ ! -d $folder ]] && mkdir -p $folder	
	done

    count_input_files=$(ls -1q ${INPUT}*.pdf | wc -l)

    #check input content 
    if [ $count_input_files -gt 0 ]
    then
        OUTPUTFILE="$(date '+%Y%m%d%H%M%S').txt"
        
        readarray -t input_folder <<<"$(ls ${INPUT}*.pdf)"
        font_fix
else 
    echo ${fontfix_text3[$lang]}
fi


}

#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------
#                   Menu session
#------------------------------------------------------------------------------------------------------------------------
#------------------------------------------------------------------------------------------------------------------------

# Display the splash
clear

# Menu options
splash(){
    echo -ne "                                                                                             
${c4}


            | | / _| / _| / _|
  _ __    __| || |_ | |_ | |_ 
 |  _ \  / _  ||  _||  _||  _|
 | |_) || (_| || |  | |  | |  
 | .__/  \__,_||_|  |_|  |_|  
 | |  ${normal}${splash_text1[$lang]}${c4}                        
 |_|  ${normal}${splash_text2[$lang]}



"
check_env


}
splash
