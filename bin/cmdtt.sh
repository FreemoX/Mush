#!/bin/bash
cmdtt=""
cmdttr="-1"
cmdtt="$1"
if ! command -v "$cmdtt" &> /dev/null; then
    echo ""
    echo ""$cmdtt" could not be found, installing it"
    echo ""
    sudo apt update && sudo apt install "$cmdtt" -y && wait
    cmdttr="0"
    if ! command -v "$cmdtt" &> /dev/null; then
        echo ""
        echo ""$cmdtt" has been installed"
        echo ""
        cmdttr="1"
    fi
else
    echo ""$cmdtt" is installed"
    cmdttr="1"
fi
