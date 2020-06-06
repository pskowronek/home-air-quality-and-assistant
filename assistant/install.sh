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
echo " - see ./init_model.sh for details"
echo " - run: pip3 install -r requirements.txt"
echo ""
echo "Press Enter to continue the automatic precedure, otherwise press CTRL-C..."
read

echo "Installing python modules..."
pip3 install -r requirements.txt

echo "Initializing model..."
./init.model.sh

