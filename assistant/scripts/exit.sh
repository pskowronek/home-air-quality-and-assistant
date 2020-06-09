#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display &
(show_terminal "TERM_25"; echo 'Bye!' | pv -qL 20 > $TERM_25; sleep 3s; hide_terminal "TERM_25") &

aplay res/exit.wav
sleep 2s
brightness_normal
