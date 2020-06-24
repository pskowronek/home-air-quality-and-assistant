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

# Using stonks.icu (https://github.com/ericm/stonks)
(show_terminal "TERM_6"; curl -m 10 stonks.icu/pega > $TERM_6; sleep 15s; hide_terminal "TERM_6")

