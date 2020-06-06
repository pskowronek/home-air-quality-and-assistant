#!/bin/bash

cd "$(dirname "$0")"
export DISPLAY=:0.0 

aplay res/exitctx.wav &
lxterm -fullscreen -fa 'Monospace' -fs 25 +sb -bc -e "echo 'Bye!' | pv -qL 8; sleep 2s"

# Cow is slow on my RPi :/
#lxterm -fullscreen -e "cowsay 'Bye!'; sleep 5s"
