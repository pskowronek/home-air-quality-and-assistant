#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display

# Using wttr.in to display ASCII weather.
# wttr.in is a cool thing! Check it out here https://github.com/chubin/wttr.in, more options can be seen this way: curl http://wttr.in/:help

# Using TTF fonts (-fa & -fs) instead of bitmap (-fn) to better fit into stream
xterm -class UXTerm -title HAQnR -fa 'Monospace' -fs 18 \
      -u8 -fullscreen -u8 +wf +sb -bc -baudrate 230400 +s -e "TAG=assistant; curl wttr.in/?Ftnqp0; sleep 15s" &

# One can also use lxterm which calls xterm:
#lxterm -fullscreen -fa 'Monospace' -fs 18 +sb -bc -e "TAG=assistant; curl wttr.in/?Ftnqp0; sleep 15s"
