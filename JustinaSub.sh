#!/bin/bash
# forskningsparken
forsk="https://ruter.no/reiseplanlegger/Stoppested/(3010370)Forskningsparken%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0";
if [ "$#" -eq "0" ] || ([ "$#" -eq "1" ] && ([ "$1" == "--E" ] || [ "$1" == "--W" ])); then
	input=$forsk; #default
	stations=6; #default
	echo "Departures for Forskningsparken station";
	echo " ******** "
	if [ "$#" -eq "1" ]; then
		if [ "$1" == "--E" ]; then
			ret="ret1";
			stations=3;
			echo "Direction E";
		elif [ "$1" == "--W" ]; then
			ret="ret2";
			stations=3;
			echo "Direction W";
		fi
	fi
fi

# blindern
blind="https://ruter.no/reiseplanlegger/Stoppested/(3010360)Blindern%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0";
if ([ "$#" -eq "1" ] && [ "$@" == "Blindern" ]) || ([ "$1" == "Blindern" ] && [ "$#" -eq "2" ] && ([ "$2" == "--E" ] || [ "$2" == "--W" ])); then
	input=$blind;
	stations=6;
	echo "Departures for Blindern station";
	echo " ******** "
	if [ "$#" -eq "2" ]; then
		if [ "$2" == "--E" ]; then
			ret="ret1";
			stations=3;
			echo "Direction E"
		elif [ "$2" == "--W" ]; then
			ret="ret2";
			stations=3;
			echo "Direction W"
		fi
	fi
fi

# kringsjå
kring="https://ruter.no/reiseplanlegger/Stoppested/(3012270)Kringsj%c3%a5%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0";
if ([ "$#" -eq "1" ] && [ "$@" == "Kringsjaa" ]) || ([ "$1" == "Kringsjaa" ] && [ "$#" -eq "2" ] && ([ "$2" == "--E" ] || [ "$2" == "--W" ])); then
	input=$kring;
	echo "Departures for Kringsjaa station";
	echo " ******** "
	stations=2;
	if [ "$#" -eq "2" ]; then
		if [ "$2" == "--E" ]; then
			ret="ret1";
			stations=1;
			echo "Direction E"
		elif [ "$2" == "--W" ]; then
			ret="ret2";
			stations=1;
			echo "Direction W"
		fi
	fi
fi

# upload text
input="$(curl -s $input)";

# clip the text to the one containing information about departure times
dest=${input#*":[],\"platforms\":"};
dest=${dest%% angular.module*};

# clip the text just to text about the first direction ("Retning sentrum")
if [ "$ret" == "ret1" ]; then
	dest=${dest%%",{\"name\":\"2 (Retning Sognsvann/Storo)\""*}
	# clip the text just to text about the second direction ("Retning Sognsvann/Storo")
elif [ "$ret" == "ret2" ]; then
	dest=${dest#*"}]}]},"}
fi
declare -i i
declare -i j
for (( i=0 ; i<stations ; i++ ))
do
	dest=${dest#*destination};
	echo $dest | cut -d "\"" -f3;
	for(( j=0 ; j<5 ; j++ ))
	do
		dest=${dest#*departureTime};
		if [ "$j" -eq "0" ]; then
			echo $dest | cut -d "\"" -f3;
		fi
	done
done