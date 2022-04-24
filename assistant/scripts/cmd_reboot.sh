#!/bin/bash

# Script executed as intended command.
# Args:
# $1 - voice parameters
# $2 - invocation context (the invocation name)
# $3 - sentence that was heard and resulted with calling this script

cd "$(dirname "$0")"
export DISPLAY=:0.0
export TERM=xterm
source ./_helpers.sh

brighten_display &

(show_terminal "TERM_17"; echo -e "System is going down\nFor reboot now!\n" > $TERM_17; sleep 5s; echo -e "\n\nGoing down!\n" > $TERM_17; sudo reboot now; sleep 15s; hide_terminal "TERM_17")

