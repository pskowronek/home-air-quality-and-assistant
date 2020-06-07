#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display
TO_KILL=$(pgrep -f "term.*TAG=assistant")
lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "TAG=assistant; echo 'Didnt get that. Call me again.' | pv -qL 8; sleep 2s" &
kill $TO_KILL
espeak -v+m2 -s160 -a30 -p40 "Didn't get that. Speak my name and try again."
