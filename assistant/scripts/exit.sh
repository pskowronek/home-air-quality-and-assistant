#!/bin/bash

# Script executed when ending the interaction.
# Args:
# $1 - voice parameters
# $2 - invocation context (the invocation name)

cd "$(dirname "$0")"
export DISPLAY=:0.0
export TERM=xterm
source ./_helpers.sh

brighten_display &
(clear_terminals; show_terminal "TERM_25"; echo 'Bye!' > $TERM_25; sleep 3s; hide_terminals) &

aplay res/exit.wav
brightness_normal &
