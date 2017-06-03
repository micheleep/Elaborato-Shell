#!/bin/bash
: '
richiamo la funzione secondaScelta perchè nel caso in cui il file sia vuoto non posso modificare nulla
e quindi prevengo questa cosa aggiungendo i valori all interno del file e dopodiche posso continuare
con l esecuzione della terzaScelta
'

function inserimentoNewMacAddress {
      valoreCorretto=1    #vairiabile per il ciclo while, in stile C. solamente quando sono rispettate le regole del MAC ADDRESS
                          #allora la variabile viene messa =0 e quindi si esce dal ciclo
      while (( valoreCorretto ));
      do
            valueLengthNewMacAddress=0    #variabile del numero di cifre inserite dall'utente
            while [[ $valueLengthNewMacAddress != 12 ]];    #faccio il ciclo while finchè l'utente non inserisce 12 cifre come regola
            do
                  printf "Inserire il nuovo valore del MAC ADDRESS (12 cifre hex) che andra' a sostituire il precedente e premere invio : ";
                  read valueNewMacAddress     #leggo il valore inserito dall'utente
                  valueLengthNewMacAddress=${#valueNewMacAddress}     #calcolo la lunghezza della "stringa" inserita dall'utente

                  if [[ $valueLengthNewMacAddress != 12 ]];
                  then
                        echo -e "Numero di cifre errato!\n"
                  fi
            done

            numeroCifreCorrette=0     #variabile per conteggia il numero delle cifre corrette all'interno del MAC ADDRESS
                                      #inserito precedentemente dall'utente
            for (( counter = 0; counter < valueLengthNewMacAddress; counter++ ));
            do          #substring(stringa, posizione, quanti caratteri) appartengono a [[xdigit]]
                  if [[ ${valueNewMacAddress:$counter:1} =~ [[:xdigit:]] ]];  #conto quante cifre corrette ci sono nella "stringa"
                  then
                        numeroCifreCorrette=$((numeroCifreCorrette+1))    #aumento il contatore, solo se è una cifra xdigit
                  fi
            done

            if [[ $numeroCifreCorrette == 12 ]];    #se le cifre corrette sono 12 allora il numero è corretto, possiamo sostituirlo
            then
                  echo -e "\nIl valore inserito è in forma corretta."
                  valoreCorretto=0    #possiamo uscire dal ciclo
            else
                  echo -e "\nIl valore inserito non è in forma corretta!"
                  valoreCorretto=1    #deve essere rifatto il ciclo while, deve essere inserito un nuovo valore
            fi
      done

      #solo se rinserisco lo stesso
      if [[ $valueMacAddress = $valueNewMacAddress ]];
      then
         echo -e "Non e' possibile rinserire lo stesso MAC ADDRESS!"
         exit  #chiudo lo script e non tutta l'applicazione
      fi

      #se inserisco uno che è gia nel vbox
      if [[ $(grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | grep $valueNewMacAddress | uniq | wc -l) = 1 ]];
      then
         echo -e "Non e' possibile inserire un MAC ADDRESS che e' gia presente all'interno del file $1"
         exit
      fi

      #controllo se il valore è all'interno del file database, vedo se c'è una corrispondenza (wc = 1)
      if [[ $(grep -o -i '.*' $2 | grep $valueNewMacAddress | wc -l) = 1 ]];
      then
            #se c'è allora non posso utilizzarlo e devo quindi inserire un nuovo valore per il mac address
            echo -e "E' gia presente il seguente MAC ADDRESS nel database, ripetere la procedura!"
      else
            echo -e "Non e' presente il seguente MAC ADDRESS nel database, verra' ora modificato nel file $1."
            echo -e "Viene inserito il nuovo MAC ADDRESS nel database in $2."
            echo "$valueNewMacAddress" >> $2        #inserimento del nuovo mac addresso in coda al file database
            #-o (visualizza solo le parti corrispondenti) -i(ignora maiuscoli e minuscoli) || -c (seleziono solo quei caratteri)
            #cerco nel file il valore corrispondente al mac address, vado a modificarlo con il nuovo inserito dall'utente
            #tramite l'utilizzo della funzione sed
            grep -i -o 'macaddress=".*"' $1 | cut -c13-24 | sed -i "s/$valueMacAddress/$valueNewMacAddress/g" $1
      fi
}

###########################################################################################################
echo -e ""
#conta quanti mac address ci sono all'interno
numberMacAddress=$(grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u | wc -w)
#il risultato dei valori selezionati lo metto all'interno di un array
arrayOfMacAddress=( $(grep -o -i 'macaddress=".*"' $1 | cut -c13-24 | sort -u) )

for (( i = 1; i <= numberMacAddress; i++ ));
do
    echo -e "$i.\t${arrayOfMacAddress[$i-1]}"  #stampo l'array e il suo valore
done

#al posto di fare l'inizializzazione
printf "\nInserire un valore da 1 a $numberMacAddress e premere invio : ";
read numberInsert    #valore letto dall'utente

#while finche non sono in una situazione che mi va bene
while (( $numberInsert > $numberMacAddress || $numberInsert == 0 ));
do
      printf "\nInserire un valore da 1 a $numberMacAddress e premere invio : ";
      read numberInsert    #valore letto dall'utetne
done

echo ""
valueMacAddress=${arrayOfMacAddress[$numberInsert-1]}
#passo il valore alla funzione per l'inserimento che va a sostituire il valore nella posizione
#scelta dall'utente
inserimentoNewMacAddress $1 $2 $valueMacAddress
