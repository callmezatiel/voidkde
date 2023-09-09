#!/bin/bash
# Idea by callmezatiel
# version by hhk02 and callmezatiel

# Include the functions of the other script
source "scripts/functions.sh"

# Check if user it's ROOT
if [[ $EUID -eq 0 ]]; then
    # Every code on this part run as ROOT
    # Call the functions of the functions.sh script. 
    Welcome
# Else show error message
else
    echo "ERROR: Run as root!"
fi