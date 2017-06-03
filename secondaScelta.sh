#!/bin/bash

: '
in questa funzione stampo tutti i MAC ADDRESS presenti nel file $2, se non ce ne sono mando un messaggio di errore
'

if [[ -s $2 ]];
then
      echo -e "Sono ora visualizzati tutti i MAC ADDRESS presenti nel file vbox : \n"
      cat $2
      echo -e ""
else
      echo -e "\nIl database dei MAC ADDRESS è vuoto! Nessun valore da visualizzare.\n"
fi
