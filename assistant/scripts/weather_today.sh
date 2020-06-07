#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

brighten_display
# wttr.in is a cool thing! Check it out here https://github.com/chubin/wttr.in, more options can be seen this way: curl http://wttr.in/:help
lxterm -fullscreen -fa 'Monospace' -fs 18 +sb -bc -e "curl wttr.in/?Ftnqp0; sleep 15s"
