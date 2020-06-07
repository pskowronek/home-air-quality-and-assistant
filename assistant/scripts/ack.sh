#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display
TO_KILL=$(pgrep -f "term.*TAG=assistant")
lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "TAG=assistant; echo 'Roger that!' | pv -qL 20; sleep 10s" &
espeak -v+m2 -s160 -a30 -p40 "Roger that!"
kill $TO_KILL
