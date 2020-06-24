#!/bin/bash

# Script executed as a prompt when invocation name was heard
# Args:
# $1 - voice parameters
# $2 - invocation context (the invocation name)
# $3 - sentence that was heard and resulted with calling this script

cd "$(dirname "$0")"
export DISPLAY=:0.0
export TERM=xterm
source ./_helpers.sh

brighten_display &
(show_terminal "TERM_25"; echo -e 'What can I do\nfor you?' > $TERM_25; sleep 5s) &

aplay res/enter.wav
