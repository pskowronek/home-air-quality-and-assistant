#!/bin/bash

cd "$(dirname "$0")"
export DISPLAY=:0.0 

lxterm -fullscreen -fa 'Monospace' -fs 23 +sb -bc -e "echo 'What can I do for you?' | pv -qL 20; sleep 5s" &
# cow is slow on my RPi
#lxterm -fullscreen -e "cowsay 'What can I do for you?'; sleep 20s" &
aplay res/enter.wav
