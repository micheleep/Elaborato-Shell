#!/bin/bash

: '
fa la stessa cosa della funzione tre, solo che genera numeri random
'

function generazioneRandomMacAddress {
      hexString="0123456789ABCDEF"    #stringa con tutti i valori che seguono le rogole dell'esadecimale

      for (( i = 0; i < 12; i++ ));   #genero il nuovo MAC ADDRESS casualmente
      do
        valueNewRandomMacAddress+=${hexString:$((RANDOM % 16)):1}   #con la funzione random genero un numero tra 0 e 16
      done

      echo -e "Il MAC ADDRESS generato è $valueNewRandomMacAddress."

      if [[ $(grep -o -i '.*' $2 | grep $valueNewRandomMacAddress | wc -l) = 1 ]];
      then
        echo -e "E' gia presente il seguente MAC ADDRESS nel database, ripetere la procedura!"
        break
      else
        echo -e "Non e' presente il seguente MAC ADDRESS nel database, verra' ora modificato nel file $1."
        echo -e "Viene inserito il nuovo MAC ADDRESS nel database in $2."
        echo "$valueNewRandomMacAddress" >> $2
        grep -i -o 'macaddress=".*"' $1 | cut -c13-24 | sed -i "s/$valueMacAddressInsertRandom/$valueNewRandomMacAddress/g" $1
      fi
}

###########################################################################################################
echo -e ""
numberMacAddress=$(grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u | wc -w)
arrayOfMacAddress=( $(grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u) )

for (( i = 1; i <= numberMacAddress; i++ ));
do
    echo -e "$i.\t${arrayOfMacAddress[$i-1]}"
done

printf "\nInserire un valore da 1 a $numberMacAddress e premere invio : ";
read numberInsert

while (( $numberInsert > $numberMacAddress || $numberInsert == 0 ));
do
      printf "\nInserire un valore da 1 a $numberMacAddress e premere invio : ";
      read numberInsert
done

echo ""
valueMacAddressInsertRandom=${arrayOfMacAddress[$numberInsert-1]}
generazioneRandomMacAddress $1 $2 $valueMacAddressInsertRandom
