#!/bin/bash

#Imposta il delimitatore di campo solamente al carattere a capo, rimuovendo lo spazio dalla lista di questi caratteri possiamo riferirci a righe intere contenente spazi senza trattarle come tre elementi separati.
IFS=$'\n'; 
outdir=./articoli/

for file in $(ls $outdir/Art*.txt); do \
    /bin/rm $file;
done
