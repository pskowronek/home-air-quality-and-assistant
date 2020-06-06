#!/bin/bash

cd "$(dirname "$0")"
export DISPLAY=:0.0 

espeak -v+m2 -s160 -a30 -p40 "Roger that!" &
lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "echo 'Roger that!' | pv -qL 20; sleep 1s"
# Cow is slow on my RPi :/
#lxterm -fullscreen -e "cowsay 'Roger that!'; sleep 1s" &

