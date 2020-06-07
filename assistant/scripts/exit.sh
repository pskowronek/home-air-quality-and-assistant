#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display
TO_KILL=$(pgrep -f "term.*TAG=assistant")
lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "TAG=assistant; echo 'Bye!' | pv -qL 8; sleep 2s" &
kill $TO_KILL
aplay res/exitctx.wav
sleep 2s
brightness_normal
