#!/bin/bash

nettverk1navn="Nord ITC AS - Intern"
nettverk1id="159924d6305f5d89"

echo "Hvilket nettverk ønsker du å koble til?"
echo "[1] $nettverk1navn \| $nettverk1id"
echo "[0] Avbryt"
read -p "Mitt valg: " choice

if [ $choice -eq 0 ]; then
    echo "Ok, avslutter"
    exit
elif [ $choice -eq 1 ]; then
    echo "Ok, kobler til $nettverk1navn"
    valgtnettverknavn="$nettverk1navn"
    ztID="$nettverk1id"
    sleep 2
else
    echo "Ugyldig valg. Avslutter!"
    exit
fi

clear
echo "Laster ned og installerer ZeroTier Klienten"
echo "" && echo ""

curl -s https://install.zerotier.com | sudo bash && wait

echo "" && echo ""
echo "ZeroTier er nå lastet ned."
echo "Blir med i $valgtnettverknavn"
echo "Nettverksid: $ztID"
echo "" && echo ""

sudo zerotier-cli join $ztID

echo "" && echo ""
echo "ZeroTier er nå lastet ned, og maskinen har blitt med i nettverket"
echo "Husk å godkjenn enheten på ZeroTier admin panelet"
echo ""
echo "now fuck off"
sleep 3
