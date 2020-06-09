#!/bin/bash

cd "$(dirname "$0")"
source ./_helpers.sh
export DISPLAY=:0.0

(show_terminal "TERM_25"; echo 'Hello!' > $TERM_25; sleep 5s; hide_terminal "TERM_25")
