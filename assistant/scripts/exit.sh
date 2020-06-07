#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0 

brighten_display
TO_KILL=$(pgrep -f "term.*TAG=assistant")

# using fn and bitmap fonts as they terminal starts quicker (2s vs 3.5s). TTF can be loaded by using: -fa 'Monospace' -fs 25
# list of mono fonts can be found by executing this command: xlsfonts -fn '*-*-*-*-*-*-*-*-*-*-*-m*'
xterm -class UXTerm -title HAQnR -fn "-adobe-courier-medium-r-normal--25-180-100-100-m-150-iso8859-1" \
      -u8 -fullscreen -u8 +wf +sb -bc -baudrate 230400 +s -e "TAG=assistant; echo 'Bye!' | pv -qL 8; sleep 2s" &

# One can also use lxterm which calls xterm:
#lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "TAG=assistant; echo 'Bye!' | pv -qL 8; sleep 2s" &

kill $TO_KILL
aplay res/exit.wav
sleep 2s
brightness_normal
