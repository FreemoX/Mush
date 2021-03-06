#!/bin/bash

# TO DO
#
# - Add functionality to ask the user for the name of a manually inputted network
#

# Grab the language code from the active language installed on the system
lang=$(locale | grep LANG | cut -d= -f2 | cut -d_ -f1)
path=$(pwd)

# Allows manually overriding the language, or display the help text
if [ $# -gt 0 ] && [ "$1" != "help" ]; then
    lang="$1"
elif [ $# -gt 0 ] && [ "$1" == "help" ]; then
    echo "./zt.sh <language>"
    echo "Languages:"
    echo "English: en"
    echo "Norwegian: no, nb, nn"
    exit
fi

# Default to English if no valid language was inputted
if [ $lang == "" ]; then
    lang="en"
fi

# Since Norwegian has several language codes, they will all default to the main lang code
if [ "$lang" == "nb" ] || [ "$lang" == "nn" ]; then
    lang="no"
fi

# Checks if the relevant language file is present. Defaults to English if it is not
if test -f "$path/langs/$lang.sh"; then
    . $path/langs/$lang.sh
    echo ""
    echo "$_ASSIGNED_LANGUAGE"
    echo ""
else
    . $path/langs/en.sh
    echo ""
    echo "Language not found. Reset to English"
    echo ""
fi

# Network IDs go here. Don't forget to assign additional network names in the translations accordingly
networkid_1="159924d6305f5d89"
# End of Network IDs

# Promts the user to select a predefined network, or manually type one in
choosenetwork() {
    echo "$_NETWORK_CHOICE"
    echo "[1] $_NETWORK_1_NAME | $networkid_1"
    echo ""
    echo "[9] $_NETWORK_CUSTOM"
    echo "[0] $_CANCEL"
    echo ""
    read -p "$_MY_CHOICE: " choice
}

# Checks if "curl" is installed on the system
. ../cmdtt.sh curl && wait
if [ "$cmdttr" -eq 0 ]; then
    echo ""
    echo "$_RELIES_ON_CURL"
    echo ""
    echo "$_EXITING"
    exit 0
elif [ "$cmdttr" -eq 1 ]; then
    echo ""
    echo "$_REQUIREMENTS_PRESENT"
    echo ""
else
    echo ""
    echo "$_UNKNOWN_ERROR"
    echo "$_CURL_UNKNOWN_ERROR_INSTALL"
    echo "$_EXITING"
    exit 0
fi

choosenetwork
if [ $choice -eq 0 ]; then # Abort the script
    echo "$_EXITING"
    exit
elif [ $choice -eq 1 ]; then # Connect to network 1
    echo "$_NETWORK_CONNECTING $_NETWORK_1_NAME"
    chosennetwork_name="$_NETWORK_1_NAME"
    ztID="$networkid_1"
    sleep 2
elif [ $choice -eq 9 ]; then # Manually input a network code
    echo "$_NETWORK_ENTER_CODE"
    read -p "$_NETWORK_CODE: " ztID
    echo ""
    echo "$_NETWORK_ENTERED $ztID"
    echo "$_VERIFY_CORRECT"
    echo "[1] $_YES"
    echo "[0] $_CANCEL"
    read -p "$_MY_CHOICE: " choice
    if [ $choice -eq 0 ]; then # Abort the script if the ID was incorrect
        echo "$_EXITING"
        sleep 2
        exit
    fi
else
    echo "$_INVALID_OPTION!" # Promt the user for the network ID again
    choosenetwork
fi

clear
echo "$_ZT_DOWNLOAD_AND_INSTALL"
echo "" && echo ""

iscurlinstalled

curl -s https://install.zerotier.com | sudo bash && wait # Installs the ZeroTier client

echo "" && echo ""
echo "$_ZT_DOWNLOADED"
echo "$_NETWORK_JOINING $chosennetwork_name"
echo "$_NETWORK_CODE: $ztID"
echo "" && echo ""

sudo zerotier-cli join $ztID # Joins the selected ZeroTier network

echo "" && echo ""
echo "$_ZT_SUCCESSFUL"
echo "$_ZT_APPROVE"
echo "https://my.zerotier.com/network/$ztID"
echo ""
