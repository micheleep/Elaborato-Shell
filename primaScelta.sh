#!/bin/bash

: '
in questa funzione ho deciso di stampare tutti i mac address presenti nel file $1 senza ripetizioni
'

echo -e "Sono ora visualizzati tutti i MAC ADDRESS presenti nel file vbox (in ordine crescente): \n"
#cerco la riga che contiene il valore "macaddress" ignorando maiuscolo e minuscolo con l'opzione -i
#dopodiche prendo i caratteri che sono dopo la scritta macaddress e alla fine ordino e tolgo le ripetizioni
#il carattere . sta per qualsiasi carattere, il * per una ripetizione di qualsiasi carattere
grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u     #stampo a video l'esecuzione del comando
echo -e ""
