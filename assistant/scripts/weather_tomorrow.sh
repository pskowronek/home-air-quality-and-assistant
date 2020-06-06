#!/bin/bash

cd "$(dirname "$0")"
export DISPLAY=:0.0

# wttr.in is a cool thing! Check it out here https://github.com/chubin/wttr.in, more options can be seen this way: curl http://wttr.in/:help
lxterm -fullscreen -fa 'Monospace' -fs 8 +sb -bc -e "curl wttr.in/?Ftnqp1; sleep 15s"


