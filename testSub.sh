#!/bin/bash
forsk="https://ruter.no/reiseplanlegger/Stoppested/(3010370)Forskningsparken%20%5bT-bane%5d%20(Oslo)/Avganger/#st:1,sp:0,bp:0";
input="$(curl -s $forsk)";
dest=${input#*":[],\"platforms\":"};
dest=${dest%% angular.module*};
echo $dest;