#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

(show_terminal "TERM_25"; echo 'Hello!' | pv -qL 20 > $TERM_25; sleep 5s; show_main)
