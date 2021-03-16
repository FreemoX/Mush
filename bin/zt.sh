#!/bin/bash

lang=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1)

if [ $# -gt 0 ] && [ "$1" != "help" ]; then
    lang="$1"
elif [ $# -gt 0 ] && [ "$1" == "help" ]; then
    echo "./zt.sh <language>"
    echo "Languages:"
    echo "English: en"
    echo "Norwegian: no, nb, nn"
fi

if [ $lang == "" ]; then
    lang="en"
fi

if [ "$lang" == "en" ]; then
    _ASSIGNED_LANGUAGE="Language was manually set to English"
    _NETWORK_CHOICE="Which network would you like to join?"
    _NETWORK_1_NAME="Nord ITC AS - Internal"
    _NETWORK_CUSTOM="Custom"
    _NETWORK_CONNECTING="Ok, connecting"
    _NETWORK_ENTER_CODE="Ok, input the network ID"
    _NETWORK_CODE="Network ID"
    _NETWORK_ENTERED="You wrote"
    _NETWORK_JOINING="Now joining the network"
    _CANCEL="Cancel"
    _MY_CHOICE="My choice"
    _INVALID_OPTION="Invalid option"
    _YES="Yes"
    _NO="No"
    _EXITING="Ok, aborting"
    _VERIFY_CORRECT="Is this correct?"
    _ZT_DOWNLOAD_AND_INSTALL="Downloading and installing the ZeroTier client"
    _ZT_DOWNLOADED="ZeroTier is now downloaded"
    _ZT_SUCCESSFUL="ZeroTier is now installed, and this machine has joined the network"
    _ZT_APPROVE="Remember to approve this device on the ZeroTier admin panel from the URL below"
# End of english translations

elif [ "$lang" == "nb" ] || [ "$lang" == "nn" ] || [ "$lang" == "no" ]; then
    _ASSIGNED_LANGUAGE="Språket var manuelt satt til Norsk"
    _NETWORK_CHOICE="Hvilket nettverk ønsker du å koble til?"
    _NETWORK_1_NAME="Nord ITC AS - Intern"
    _NETWORK_CUSTOM="Egendefinert"
    _NETWORK_CONNECTING="Ok, kobler til"
    _NETWORK_ENTER_CODE="Ok, skriv inn nettverkskoden"
    _NETWORK_CODE="Nettverkskode"
    _NETWORK_ENTERED="Du skrev inn"
    _NETWORK_JOINING="Blir nå med i nettverket"
    _CANCEL="Avbryt"
    _MY_CHOICE="Mitt valg"
    _INVALID_OPTION="Ugyldig valg"
    _YES="Ja"
    _NO="Nei"
    _EXITING="Ok, avslutter"
    _VERIFY_CORRECT="Er dette korrekt?"
    _ZT_DOWNLOAD_AND_INSTALL="Laster ned og installerer ZeroTier Klienten"
    _ZT_DOWNLOADED="ZeroTier er nå lastet ned"
    _ZT_SUCCESSFUL="ZeroTier er nå installert, og maskinen har blitt med i nettverket"
    _ZT_APPROVE="Husk å godkjenn enheten på ZeroTier admin panelet fra lenken under"
# End of norwegian translations
fi

nettverk1id="159924d6305f5d89"

choosenetwork() {
    echo "$_NETWORK_CHOICE"
    echo "[1] $_NETWORK_1_NAME | $nettverk1id"
    echo ""
    echo "[9] $_NETWORK_CUSTOM"
    echo "[0] $_CANCEL"
    echo ""
    read -p "$_MY_CHOICE: " choice
}

choosenetwork
if [ $choice -eq 0 ]; then
    echo "$_EXITING"
    exit
elif [ $choice -eq 1 ]; then
    echo "$_NETWORK_CONNECTING $_NETWORK_1_NAME"
    valgtnettverknavn="$_NETWORK_1_NAME"
    ztID="$nettverk1id"
    sleep 2
elif [ $choice -eq 9 ]; then
    echo "$_NETWORK_ENTER_CODE"
    read -p "$_NETWORK_CODE: " ztID
    echo ""
    echo "$_NETWORK_ENTERED $ztID"
    echo "$_VERIFY_CORRECT"
    echo "[1] $_YES"
    echo "[0] $_CANCEL"
    read -p "$_MY_CHOICE: " choice
    if [ $choice -eq 0 ]; then
        echo "$_EXITING"
        sleep 2
        exit
    fi
else
    echo "$_INVALID_OPTION!"
    choosenetwork
fi

clear
echo "$_ZT_DOWNLOAD_AND_INSTALL"
echo "" && echo ""

curl -s https://install.zerotier.com | sudo bash && wait

echo "" && echo ""
echo "$_ZT_DOWNLOADED"
echo "$_NETWORK_JOINING $valgtnettverknavn"
echo "$_NETWORK_CODE: $ztID"
echo "" && echo ""

sudo zerotier-cli join $ztID

echo "" && echo ""
echo "$_ZT_SUCCESSFUL"
echo "$_ZT_APPROVE"
echo "https://my.zerotier.com/network/$ztID"
echo ""
