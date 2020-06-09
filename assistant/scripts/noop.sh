#!/bin/bash

# Script executed when nothing (no command) was understood while being in invocation context.
# Args:
# $1 - voice parameters
# $2 - invocation context (the invocation name)
# $3 - sentence that was heard and resulted with calling this script

cd "$(dirname "$0")"
export DISPLAY=:0.0
export TERM=xterm
source ./_helpers.sh

brighten_display &
(show_terminal "TERM_25"; echo -e "Didn't get that.\nCall me again!" > $TERM_25; sleep 5s) &

espeak $1 "Didn't get that. Speak my name and try again."
