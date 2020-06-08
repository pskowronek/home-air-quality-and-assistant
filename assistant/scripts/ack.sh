#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display
(show_terminal "TERM_25"; echo 'Roger that!' | pv -qL 20 > $TERM_25; sleep 5s; show_main) &

espeak -v+m2 -s160 -a30 -p40 "Roger that!"
