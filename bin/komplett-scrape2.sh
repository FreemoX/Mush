#!/bin/bash

# CONSTS #
sn="1"
baseurl="https://komplett.no/product/"
wf="workfile.tmp"
wfb="$wf.base"

# VARS #
n=$sn
an=$2
en="$(($sn + $an + 1))"

# FUNCS #
printhelp() {
    echo "syntax: ./komplett-scrape2.sh <sn> <an>"
    echo "<sn> = Starting product number"
    echo "<an> = how many product pages to scrape"
    echo ""
    echo "Default scrape amount: 100 products"
}

grabproductpage() {
    curl -sL $baseurl$n > $wfb
    testproductexists="$(cat $wfb | grep "Denne varen finnes ikke lenger" | cut -d ";" -f 8 | cut -c -23)"
    echo "$testproductexists"
    if [ "$testproductexists" == "Denne varen finnes ikke lenger" ]; then
        productexists=0
    elif [ "$testproductexists" != "Denne varen finnes ikke lenger" ]; then
        productexists=1
    else
        productexists=-1
    fi
    echo "Produktet eksisterer: $productexists"
}

grabpoductinfo() {
    cat $wfb | grep dataLayer.push...productId > $wf

    productid="$(cat $wf | cut -d "\"" -f 4)"
    productname="$(cat $wf | cut -d "{" -f 5 | cut -c 9- | cut -d "\"" -f 1)"
    productprice="$(cat $wf | cut -d ":" -f 5 | cut -d "." -f 1)"
    productbrand="$(cat $wf | cut -d "{" -f 5 | cut -d ":" -f 5 | cut -d "\"" -f 2)"
}

printproductinfo() {
    echo ""
    echo "Produktnavn:             "$productname""
    echo "Pris:                    "$productprice""
    echo ""
    echo "Produsent:               "$productbrand""
    echo "Varenummer:              "$productid""
    echo "URL:                     "$baseurl$n""
    echo ""
    echo "Testet $n / $en"
    echo "- - - - - - - - - - - - - - - - - - - - - - - - - - -"
}

# MAIN #
grabproductpage
if [ $productexists -eq 1 ]; then
    grabpoductinfo
    printproductinfo
elif [ $productexists -eq 0 ]; then
    echo "Produktet finnes ikke"
else
    echo "!!! Feil !!!"
    echo "Produkttest ga verken "1" eller "0"!"
fi