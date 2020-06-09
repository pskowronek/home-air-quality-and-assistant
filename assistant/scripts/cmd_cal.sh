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

(show_terminal "TERM_17"; script --flush --quiet --command cal > $TERM_17; sleep 15s; hide_terminal "TERM_17")

