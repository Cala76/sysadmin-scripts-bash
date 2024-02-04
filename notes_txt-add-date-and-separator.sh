#!/bin/bash

# Author: Lic. Guillermo Galeano Fernández
# Date: 2024-02-04
# Objective: Automatically add date in long format to the notes.txt file.
# License: GPL v3.

# Tested with:
#$ dpkg -l | grep -E '\ bash\ \ |base\-files |pluma\ ' 
#ii  base-files                            12.4+deb12u4                        amd64        Debian base system miscellaneous files
#ii  bash                                  5.2.15-2+b2                         amd64        GNU Bourne Again SHell
#ii  pluma                                 1.26.0-1                            amd64        official text editor of the MATE desktop environment



# To DO:
# Add a verification to not insert the lines if they was added some time before in the day.
# Test Case Example: To open the file two or more times in the day.


#$ date '+%A %d de %B del %Y'
#martes 21 de noviembre del 2023

#$ date --help
#Modo de empleo: date [OPCIÓN]... [+FORMATO]

#FORMATO controla la salida. Las secuencias que se interpretan son:

#  %A   el nombre local completo del dìa en la semana (p. ej., Domingo)
#  %B   el nombre local completo del mes (p. ej. Enero)
#  %d   el día del mes (p. ej., 01)
#  %Y   el año

#
DAY_STRING="`date +%A`"
DAY_NUMBER="`date +%d`"
MONTH="`date +%B`"
YEAR="`date +%Y`"

# Long format example:
#echo "Jueves 09 de noviembre del 2017"
FULL_DATE=$(echo ${DAY_STRING^}" "$DAY_NUMBER" de "$MONTH" del "$YEAR)

OUT_FILE="/home/calabaza/Documents/notes.txt"
#OUT_FILE="test-notes.txt"
#OUT_FILE="$1"

EDITOR="pluma"
#EDITOR="cat"


echo "===================================================================================" >> $OUT_FILE
echo $FULL_DATE  >> $OUT_FILE
echo "===================================================================================" >> $OUT_FILE
echo -e "----------------------------------------------------------------------------------- \n" >> $OUT_FILE

eval $EDITOR $OUT_FILE 
