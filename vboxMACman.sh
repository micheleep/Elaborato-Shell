#!/bin/bash

pathEsecuzioneScript=$(pwd)      #salvo in una varaibile il path di esecuzione dello script

########## PARTE DI CONTROLLO DEI FILE ##########
if [[ $# != 2 ]]; #controllo numero di argomenti inseriti all'inizio, se è corretto per l'esecuzione del programma
then
      echo -e "\nNon è possibile continuare con l'esecuzione del programma, numero di argomenti non corretto!"
      echo -e "Argomento 1 : name_of_file.vbox"
      echo -e "Argomento 2 : name_of_file\n"
      exit
fi

if [[ !(-f $1) ]];    #controllo del primo file
then
      clear
      echo -e "Non esiste il file selezionato in $1.\nControllare che il nome del file sia corretto.\nChiusura dell'esecuzione del programma!\n"
      exit
fi

if [[ !(-f $2) ]];    #controllo del secondo file
then
      clear
      echo -e "Non esiste il file selezionato in $2.\nCreo il file selezionato e riprendo con l'esecuzione del programma.\n"
      cd $(dirname $1)
      filename=$(basename "$2")     #con basename prendo il nome del file, quello inserito come db dei macaddress
      touch $filename               #creo il db dei macaddress
      printf "Premere INVIO per continuare > ";
      read keyPress
fi
########## FINE PARTE DI CONTROLLO DEI FILE ##########

clear
: '
#######################################################################################################
############################################ MAIN PRINCIPALE ##########################################
#######################################################################################################
'

cd $pathEsecuzioneScript   #mi sposto nel path di esecuzione dello script

while [[ $choice != 6 ]]
do
      bash ./stampaMenu.sh
      read choice
      case $choice in
            1)  bash ./primaScelta.sh $1 ;;
            2)  bash ./secondaScelta.sh $1 $2 ;;
            3)  bash ./terzaScelta.sh $1 $2 ;;
            4)  bash ./quartaScelta.sh $1 $2 ;;
            5)  clear
                echo -e "Esecuzione dello script terminata!\n"
                exit ;;
            *)  echo -e "Inserire un valore corretto per il programma!\n" ;;
      esac

      printf "Premere INVIO per continuare > ";
      read keyPress

      clear  #pulisco lo schermo dopo aver completato l'esecuzione del programma prescelto
done
