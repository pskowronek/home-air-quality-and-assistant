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

# Using wttr.in to display ASCII weather.
# wttr.in is a cool thing! Check it out here https://github.com/chubin/wttr.in, more options can be seen this way: curl http://wttr.in/:help
(show_terminal "TERM_8"; curl -L -m 3 wttr.in/?Ftnqp1 > $TERM_8; sleep 15s; hide_terminal "TERM_8")

