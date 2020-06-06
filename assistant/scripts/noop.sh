#!/bin/bash

cd "$(dirname "$0")"
export DISPLAY=:0.0 

lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "echo 'Didnt get that. Call me again.' | pv -qL 8; sleep 2s" &
# Cow is slow on my RPi :/
#lxterm -fullscreen -e "cowsay 'Didnt get that. Call me again.'; sleep 5s" &

espeak -v+m2 -s160 -a30 -p40 "Didn't get that. Speak my name and try again."
