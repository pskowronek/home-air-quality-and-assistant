#!/bin/bash

# Script executed when assistant is initializing to prepare things in the environment
# (see _helpers.sh) and to say hello.

cd "$(dirname "$0")"
export DISPLAY=:0.0
export TERM=xterm
source ./_helpers.sh

(show_terminal "TERM_25"; echo 'Hello!' > $TERM_25; sleep 5s; hide_terminal "TERM_25")
