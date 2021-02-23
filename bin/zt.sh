#!/bin/bash

echo "Remember you can specify the network ID"
echo "after calling this script, eg: "
echo "./zt.sh <NETWORKID>"
echo ""
read -s -p "Press any key to continue" i && i=""

if [ $# -gt 0 ]; then
    ztID=$1
else
    ztID="159924d6305f5d89"
fi

clear
echo "Laster ned og installerer ZeroTier Klienten"
echo "" && echo ""

curl -s https://install.zerotier.com | sudo bash && wait

echo "" && echo ""
echo "ZeroTier er nå lastet ned."
echo "Blir med i Nord ITC AS Intern VPN"
echo "Nettverksid: $ztID"
echo "" && echo ""

sudo zerotier-cli join $ztID

echo "" && echo ""
echo "ZeroTier er nå lastet ned, og maskinen har blitt med i nettverket"
echo "Husk å godkjenn enheten på ZeroTier admin panelet"
echo ""
echo "now fuck off"
sleep 10
