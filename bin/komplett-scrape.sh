#!/bin/bash
#cd /tmp
#currencysymbols=[",-", "kr"]
currencysymbol=",-"
sn="1167964"
n="$sn"
en="1168100"
csvdelim=";"
waitdur="0"
productsfound=0
productsnotfound=0
productssearched=0

here="$($pwd)"

_NOTFOUND="Ikke funnet"

logfile="webscrape-komplett.log"
workfile="tmp_file"
extractfile="komplett.no-extractData.csv"

deps=(\
"cat" \
"cut" \
"grep" \
"lynx" \
)

# grep -A(fter) 1(additional line)
# sed '1d'                          Remove the first line
# cut -c(ollumns) 4-                Cuts the first 4 collumns

# Checks if the correct arguments have been inputted
checkargs() {
    if [[ "$@" == "--help" ]]; then
        echo ""
        echo "./komplett-scrape.sh <sp> <ep>"
        echo ""
        echo "<sp> = Start product; The product ID for the first product to be scanned"
        echo "<ep> = End product; The product ID for the last product to be scanned"
        echo ""
        exit 1;
    elif [ $# -lt 2 ]; then
        echo ""
        echo "!!! Invalid arguments !!!"
        echo "Correct syntax is: ./komplett-scrape.sh <sp> <ep>"
        echo ""
        echo "Run "!! --help" for more help"
        echo ""
        exit 1;
    fi
}

# Removes any spaces and currency symbols from the prices
cleanprices() {
    foo=bar
}

# Grabs relevant info from the scrape file
grabinfo() {
    in="$1"     # in = Information Name
    iv=""       # iv = Information Value
    if [ "$1" == "0" ]; then       # Grabs the productname
        iv=$(cat "$workfile" | grep -A 1 "Her er du:" | sed '1d' | cut -c 4-)
    elif [ "$1" == "1" ]; then     # Grabs the produktnumber
        iv=$n
    elif [ "$1" == "2" ]; then     # Grabs the producer productnumber
        iv=$(cat "$workfile" | grep "Produktnr\.\:.*." | cut -f 2 -d '/' | cut -c 14- | cut -f 1 -d ' ')
    elif [ "$1" == "3" ]; then     # Grabs the price
        iv=$(cat "$workfile" | grep ^\.*\,\-$ | cut -c 4- | tr -d $currencysymbol | tr -d ' ')
        #cleanprices
    fi
    if [ "$iv" != "" ]; then
        iv="$iv"
    else
        iv="$_NOTFOUND"
    fi
}

writetolog() {
    now=$(date +"%H:%m:%S %d-%m-%y")
    if [ $1 == "start" ]; then
        echo "Webscrape startet      "$now"" >> "$logfile"
        logstate=1
    elif [ $1 == "end" ]; then
        echo "Webscrape fullført     "$now"" >> "$logfile"
        logstate=2
    else
        echo "Error: Logstate invalid"
        exit 1;
    fi
}

checkinstalledfunc() {
    cmdtt=""
    cmdttr="-1"
    cmdtt="$1"
    if ! command -v "$cmdtt" &> /dev/null
    then
        echo ""$cmdtt" could not be found"
        cmdttr="0"
        echo "Attempting to install "$cmdtt""
        sudo apt update && sudo apt install "$cmdtt" -y
    else
        echo ""$cmdtt" is installed"
        cmdttr="1"
    fi
}

checkinstalled() {
    checkinstalledfunc lynx && wait
    cmdttrLynx=$cmdttr
    checkinstalledfunc grep && wait
    cmdttrGrep=$cmdttr
    checkinstalledfunc cut && wait
    cmdttrCut=$cmdttr
    checkinstalledfunc cat && wait
    cmdttcat=$cmdttr
    echo "" && echo ""
}

checkinstalled
writetolog start

# checkargs         # Function has not yet been completely implemented, and has thus been disabled

rm "$workfile" "$extractfile" && wait
echo "Produktnavn"$csvdelim"Varenummer"$csvdelim"Produktnummer"$csvdelim"URL"$csvdelim"Pris" > "$extractfile"
while [ "$n" -lt "$en" ]; do
    lynx --dump https://www.komplett.no/product/$n > "$workfile" && wait && sleep $waitdur

    existing=$(cat "$workfile" | grep ^Produktinfo)
    if [ "$existing" == "Produktinfo" ]; then

        grabinfo 0 && productname="$iv"
        grabinfo 1 && productnumber="$iv"
        grabinfo 2 && producerproductnumber="$iv"
        grabinfo 3 && price="$iv"

        echo ""
        echo "Produktnavn: "$productname""
        echo "Varenummer: "$n""
        echo "Produktnummer: $producerproductnumber"
        echo "URL: https://www.komplett.no/product/$n"
        echo "Pris: "$price""
        echo ""
        echo "Testet $n / $en"
        echo "- - - - - - - - - - - - - - - - - - - - - - - - - - -"
        echo ""$productname"$csvdelim"$n"$csvdelim"$producerproductnumber"$csvdelim"https://www.komplett.no/product/$n"$csvdelim"$price"" >> "$extractfile"
        productsfound=$(($productsfound+1))
    else
        echo ""
        echo "Produkt nr $n ble ikke funnet"
        echo "Testet $n / $en"
        echo "- - - - - - - - - - - - - - - - - - - - - - - - - - -"
        productsnotfound=$(($productsnotfound+1))
    fi
    n=$[$n+1]
    productssearched=$(($productssearched+1))
    sleep $waitdur
done
echo "" && echo ""
echo "Fant $productsfound av $(($productsfound+$productsnotfound)) produkt(er) - ("$productsnotfound" produktsider eksisterte ikke)"

writetolog end
echo "Fant $productsfound av $(($productsfound+$productsnotfound)) produkt(er) - ("$productsnotfound" produktsider eksisterte ikke)" >> "$logfile"
echo "" >> $logfile

# sudo mv "$extractfile" /home/$USER/""$extractfile"-"$now".csv"