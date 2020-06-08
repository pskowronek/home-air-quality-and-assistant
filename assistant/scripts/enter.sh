#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display
(show_terminal "TERM_25"; echo 'What can I do for you?' | pv -qL 20 > $TERM_25; sleep 5s; show_main) &

aplay res/enter.wav
