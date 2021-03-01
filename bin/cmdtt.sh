#!/bin/bash
cmdtt=""
cmdttr="-1"
cmdtt="$1"
if ! command -v "$cmdtt" &> /dev/null
then
    echo ""$cmdtt" could not be found"
    cmdttr="0"
else
    echo ""$cmdtt" is installed"
    cmdttr="1"
fi
