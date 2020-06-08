#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display
(show_terminal "TERM_25"; echo -e "Didn't get that.\nCall me again!" | pv -qL 25 > $TERM_25; sleep 5s; show_main) &

espeak -v+m2 -s160 -a30 -p40 "Didn't get that. Speak my name and try again."
