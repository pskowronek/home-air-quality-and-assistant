#!/bin/bash

# A script to install all requirements for the assistant, namely:
# - python3 modules
# - initializes acoustic model

cd "$(dirname "$0")"

echo "This script is about to:"
echo " - install python requirements for the assistant"
echo " - initialize acoustic model for offline use"
echo ""
echo "If you prefer to do it manually then:"
echo " - run: pip3 install -r requirements.txt"
echo " - see ./init_model.sh for details"
echo ""
read -p "Do you want to continue the automatic precedure? (Y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Installing python modules..."
    pip3 install -r requirements.txt
    echo
    echo "Initializing model..."
    ./init_model.sh
fi
