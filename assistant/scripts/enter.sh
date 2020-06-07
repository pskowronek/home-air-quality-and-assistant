#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display
TO_KILL=$(pgrep -f "term.*TAG=assistant")
lxterm -fullscreen -fa 'Monospace' -fs 23 +sb -bc -e "TAG=assistant; echo 'What can I do for you?' | pv -qL 20; sleep 5s" &
kill $TO_KILL
aplay res/enter.wav
