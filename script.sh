#!/bin/bash

#Imposta il delimitatore di campo solamente al carattere a capo, rimuovendo lo spazio dalla lista di questi caratteri possiamo riferirci a righe intere contenente spazi senza trattarle come tre elementi separati.
IFS=$'\n'; 
infile=./Costituzione-completa-aperta.txt
outdir=articoli/


#Per ogni riga che inizia con 'Art. ' continua con il numero dell'articolo e finisce con . all' interno del file costituzione_final.txt, prepara le righe ad essere nomi di files, rimuovi "." e spazio e salva in variable dedicata, poi salva un file per ogni articolo trovato inizialmente contenente le 100 righe successive alla riga dell'articolo stesso, e taglia quando trovi l'inizio del prossimo articolo con 'Art. ' 
for i in $(grep --color=never -E "^Art\. [0-9]+\..*$" $infile ); do
    filename_dirty=$(echo $i); 
    filename_clean=$(echo $filename_dirty | sed 's/[. ]//g'); 
    grep -A 100 "$i" "$infile" | sed -n "/$i/, /Art\./p" > "$outdir/$filename_clean.txt"; 
done


#Codice pezza per rimuovere le parentesi dai nomi dei files, alcuni articoli come art9 esistono solo in versione9(1), quindi riferirsi a quei files diventa complicato poiché scatta l'interpretazione da parte del terminale
for initial_filename in $(ls $outdir/Art*.txt); do
    final_filename=$(echo "$initial_filename" | sed 's/[()]/-/g'); 
    mv "$initial_filename" "$final_filename"; done


#Per ogni file articolo sovrascrivi il file originale con la sua copia contenente solamente dalla prima riga all'inizio del prossimo capitolo, la seconda occorrenza di 'Art. '.
for file in $(ls $outdir/Art*.txt); do  
       total_lines=$(wc -l < "$file"); 
       lines_to_keep=$((total_lines - 1)); 
       head -n "$lines_to_keep" "$file" | sed -E 's/^[0-9]+$//g' | sed -E 's/^$//g' | sed '/^$/N;/^\n$/D' > "$file.tmp";
        
       mv "$file.tmp" "$file"; 
done

#todo le intestazioni 
