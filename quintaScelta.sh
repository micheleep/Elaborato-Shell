#!/bin/bash

: '
in questa funzione stampo tutti i valori presenti nel file .vbox all interno del file databse, li esporto
'

echo -e "Esportazione di tutti i MAC ADDRESS contenuti nel file .vbox all'interno del database."
grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u >> $2
sort -u $2 
