#!/bin/bash

forsk="https://ruter.no/reiseplanlegger/Stoppested/(3010370)Forskningsparken%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0"
blind="https://ruter.no/reiseplanlegger/Stoppested/(3010360)Blindern%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0"

if ([ "$#" -ne "0" ] && ([ "$1" -eq "Blindern" ] || [ "$2" -eq "Blindern"])); then
	input="$(curl -s $blind)"
	if ([ "$#" -eq "2" ] && ([ "$1" -eq "E" ] || [ "$2" -eq "E" ])); then
		ret="E"
		echo "Neste avganger fra Blinder i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" -eq "W" ] || [ "$2" -eq "W" ])); then
		ret="W"
		echo "Neste avganger fra Blindern i vestgående rettning"
	else
		echo "Neste avganger fra Blindern"
	fi 
elif ([ "$#" -ne "0" ] && [ "$1" -eq "Majorstuen" ]); then
	input="$(curl -s $major)"
	if ([ "$#" -eq "2" ] && ([ "$1" -eq "E" ] || [ "$2" -eq "E" ])); then
		ret="E"
		echo "Neste avganger fra Majorstuen i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" -eq "W" ] || [ "$2" -eq "W" ])); then
		ret="W"
		echo "Neste avganger fra Majorstuen i vestgående rettning"
	else
		echo "Neste avganger fra Majorstuen"
	fi 
else
	input="$(curl -s $forsk)"
	echo "Neste avganger fra Forskningsparken"
	if (([ "$#" -eq "2" ] || [ "$#" -eq "1" ]) && ([ "$1" -eq "E" ] || [ "$2" -eq "E" ])); then
		ret="E"
		echo "Neste avganger fra Majorstuen i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" -eq "W" ] || [ "$2" -eq "W" ])); then
		ret="W"
		echo "Neste avganger fra Majorstuen i vestgående rettning"
	else
		echo "Neste avganger fra Majorstuen"
	fi 
fi

dest=${input#*":[],\"platforms\":"}
dest=${dest%% angular.module*}


#echo $dest

longstring="(apples(oranges(pears)bananas)coconuts)"
longstring=${longstring##*(}
longstring=${longstring%%)*}
#echo $longstring #pears

longstring="tes":{"x":596132,"y":6646383},"deviations":[],"platforms":[{"name":"1 (Retning sentrum)","isHub":false,"lines":[{"id":4,"name":"4","destination":"Bergkrystallen via Majorstuen","transportation":8,"transportationName":"T-bane","lineColor":"F07800","deviations":[],"departures":[{"tripId":"500040067","tripTime":"080920161402","isLowFloor":false,"departureTime":"14:02","isRemainingTime":true,"isInCongestio"
longstring=${longstring##*platforms}
#longstring=${longstring%%)*}
#echo $longstring #pears

#longstring="(apples(oranges(pears)bananas)coconuts)"
input=${input##*Retning sentrum}
#input=${input##*false,}
#input=${input%%via*}
#echo $longstring #pears
avgang=${input#*destination}
avgang=${avgang%%transportation*}
dtime=${input#*departureTime}
dtime=${dtime%%isRemainingTime*}
#echo $avgang
#echo $dtime
#echo $input
#testteskst="tes":{"x":596132,"y":6646383},"deviations":[],"platforms":[{"name":"1 (Retning sentrum)","isHub":false,"lines":[{"id":4,"name":"4","destination":"Bergkrystallen via Majorstuen","transportation":8,"transportationName":"T-bane","lineColor":"F07800","deviations":[],"departures":[{"tripId":"500040067","tripTime":"080920161402","isLowFloor":false,"departureTime":"14:02","isRemainingTime":true,"isInCongestio"
#echo $testteskst
#myString="Dette er en Tekst jeg bruker til å teste substring greier"
#myString2=${mystring#* }
#echo $myString2
#testteskst2=${testteskst#*destination}
#tekst1=${input%*","destination":"}
#echo $tekst1
#dest=${input#*":[],\"platforms\":"}
#dest=${dest%% angular.module*}
#echo $dest;
#dest=${dest%%",{\"name\":\"2 (Retning Sognsvann/Storo)\""*}
