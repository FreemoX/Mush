#!/bin/bash

ptc() {     # Press any key To Continue
    read -p "Press any key to continue"
}

checkdiskspace() {
    df -h | grep /dev/$disktocheck
}

checkpartnerchannels() {
    teststring="deb http://archive.canonical.com/ubuntu focal partner"
    test="$(cat /etc/apt/sources.list | grep ^deb.http...archive\.canonical\.com\/ubuntu | grep partner$)"
    if [ "$test" != "$teststring" ]; then
        checkpartnerchannelsresult="0"
        sudo echo "" >> /etc/apt/sources.list
        sudo echo "# Partner channels" >> /etc/apt/sources.list
        sudo echo "$teststring" >> /etc/apt/sources.list
        sudo apt update
        checkpartnerchannels
    elif [ "$test" == "$teststring" ]; then
        checkpartnerchannelsresult="1"
    else
        echo "Test for partner channels failed, exiting ..." && sleep 1
        exit;
    fi
}

# lsblk | grep sd..
# read -p "Disk to check. eg \"sda\": " disktocheck
# checkdiskspace
# sudo adduser openkm
# ptc
# if [ checkpartnerchannelsresult -ne "1" ]; then
#     echo "Test for partner channels failed, exiting ..." && sleep 1
#     exit;
# fi
# wget -Nc smxi.org/inxi
# sudo chmod +x inxi
# sudo ./inxi -F
ptc
pamdcat="$(cat /etc/pam.d/su)"
pamdcattest="$(cat /etc/pam.d/su | grep pam_limits\.so$ | cut -d " " -f 1)"
echo "pamdcat result"
echo "$pamdcat"
echo ""
echo "pamdcattest result"
echo "$pamdcattest"
echo ""
pamdcatteststring="session"
if [ "$pamdcattest" == "$pamdcatteststring" ]; then
    echo "ok"
elif [ "$pamdcattest" == "#$pamdcatteststring" ]; then
    echo "not ok"
else
    echo "?!? WTF ?!?"
fi