#!/bin/bash

forsk="https://ruter.no/reiseplanlegger/Stoppested/(3010370)Forskningsparken%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0"
blind="https://ruter.no/reiseplanlegger/Stoppested/(3010360)Blindern%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0"
major="https://ruter.no/reiseplanlegger/Stoppested/(3010200)Majorstuen/Avganger#st:1,sp:0,bp:0"
ret="any"
echo
if ([ "$#" -ne "0" ] && ([ "$1" == "Blindern" ] || [ "$2" == "Blindern" ])); then
	input="$(curl -s $blind)"
	if ([ "$#" -eq "2" ] && ([ "$1" == "E" ] || [ "$2" == "E" ])); then
		ret="E"
		echo "Neste avganger fra Blinder i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" == "W" ] || [ "$2" == "W" ])); then
		ret="W"
		echo "Neste avganger fra Blindern i vestgående rettning"
	else
		echo "Neste avganger fra Blindern"
	fi 
elif ([ "$#" -ne "0" ] && ([ "$1" == "Majorstuen" ] || [ "$2" == "Majorstuden" ])); then
	input="$(curl -s $major)"
	if ([ "$#" -eq "2" ] && ([ "$1" == "E" ] || [ "$2" == "E" ])); then
		ret="E"
		echo "Neste avganger fra Majorstuen i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" == "W" ] || [ "$2" == "W" ])); then
		ret="W"
		echo "Neste avganger fra Majorstuen i vestgående rettning"
	else
		echo "Neste avganger fra Majorstuen"
	fi 
else
	input="$(curl -s $forsk)"
	if (([ "$#" -eq "2" ] || [ "$#" -eq "1" ]) && ([ "$1" == "E" ] || [ "$2" == "E" ])); then
		ret="E"
		echo "Neste avganger fra Forskningsparken i østgående rettning"
	elif ([ "$#" -eq "2" ] && ([ "$1" == "W" ] || [ "$2" == "W" ])); then
		ret="W"
		echo "Neste avganger fra Forskningsparken i vestgående rettning"
	else
		echo "Neste avganger fra Forskningsparken"
	fi 
fi

echo
dest=${input#*":[],\"platforms\":"}
dest=${dest%% angular.module*}

test1=${dest%%",{\"name\":\"2 (Retning Sognsvann/Storo)\""*}
test2=${dest##",{\"name\":\"2 (Retning Sognsvann/Storo)\""*}


if [ $ret == "E" ]; then
	dest=${dest%%",{\"name\":\"2 (Retning Sognsvann/Storo)\""*}
elif [ $ret == "W" ]; then
	dest=${dest#*"}]}]},"}
fi

declare -i i=0
declare -i j=0

for (( i=0 ; i<6 ; i++)); do
	if [ ${#dest} -eq "0" ]; then
		break
	fi

	dest=${dest#*destination}

	test1=$dest
	test1=${test1#*'"'}
	test1=${test1#*'"'}
	test1=${test1%%'"'*}


	if [ ${#test1} -eq "5" ]; then
		break
	fi

	echo $dest | cut -d "\"" -f3
	for (( j=0 ; j<5 ; j++ )); do
		dest=${dest#*departureTime}
		if [ "$j" -eq "0" ]; then
			echo $dest | cut -d "\"" -f3
		fi
	done
	echo
done
