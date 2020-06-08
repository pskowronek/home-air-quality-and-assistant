#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display

# Using wttr.in to display ASCII weather.
# wttr.in is a cool thing! Check it out here https://github.com/chubin/wttr.in, more options can be seen this way: curl http://wttr.in/:help
(show_terminal "TERM_8"; curl wttr.in/?Ftnqp1 > $TERM_8; sleep 15s; show_main)

