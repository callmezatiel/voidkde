#!/bin/bash
# Idea by callmezatiel
# version by hhk02 and callmezatiel

# Include the functions of the other script
source "scripts/functions.sh"

# Check if user it's ROOT
if [[ $EUID -eq 0 ]]; then
    
    # Check if it's running on Void Linux

    if (cat /etc/os-release | grep "Void"); then
        echo "Void Linux Detected! Starting...."
    else
        echo "This it's not Void Linux!"
        exit
    fi
    
    # Every code on this part run as ROOT
    
    # Call the functions of the functions.sh script.

    if [ ! -f /usr/bin/dialog ]; then
        xbps-install -y dialog
    fi
    Welcome
# Else show error message
else
    echo "ERROR: Run as root!"
fi