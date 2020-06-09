#!/bin/bash

# A set of helpers - not intended for direct execution

# Pipes and desktops where terminal of given font size read data from
TERM_8="/tmp/assistant_term8.pipe"
TERM_17="/tmp/assistant_term17.pipe"
TERM_25="/tmp/assistant_term25.pipe"

function brighten_display {
    BRIGHTNESS_PID=$(pgrep brightness.sh)
    kill -HUP $BRIGHTNESS_PID
}

function brightness_normal {
    BRIGHTNESS_PID=$(pgrep brightness.sh)
    kill -CONT $BRIGHTNESS_PID
}

function init_terminals {
    if [ ! -e "$TERM_8" ]; then
        mkfifo -m 600 "$TERM_8"
    fi
    if [ ! -e "$TERM_17" ]; then
        mkfifo -m 600 "$TERM_17"
    fi
    if [ ! -e "$TERM_25" ]; then
        mkfifo -m 600 "$TERM_25"
    fi

    TERM_PID=$(pgrep -f "term.*TAG=TERM_8_")
    if [ -z "$TERM_PID" ]; then
        ( lxterm -iconic -fullscreen -title "TERM_8" -fa 'Monospace' -fs 8 +sb -bc -e "TAG=TERM_8_; tail -f $TERM_8" ) &
    fi
    TERM_PID=$(pgrep -f "term.*TAG=TERM_17_")
    if [ -z "$TERM_PID" ]; then
        ( lxterm -iconic -fullscreen -title "TERM_17" -fa 'Monospace' -fs 17 +sb -bc -e "TAG=TERM_17_; tail -f $TERM_17" ) &
    fi
    TERM_PID=$(pgrep -f "term.*TAG=TERM_25_")
    if [ -z "$TERM_PID" ]; then
        ( lxterm -iconic -fullscreen -title "TERM_25" -fa 'Monospace' -fs 25 +sb -bc -e "TAG=TERM_25_; tail -f $TERM_25" ) &
    fi
}

function show_terminal {
    init_terminals
    clear > ${!1}
    wmctrl -a $1
# this one does the same as wmctrl above, but it is 3 times quicker
#    xdotool search --maxdepth 2 --limit 1 --name $1 windowactivate &

}

function hide_terminal {
    ( xdotool search --maxdepth 2 --limit 1 --name $1 windowminimize; clear > ${!1} )&
}

function hide_terminals {
    hide_terminal "TERM_8"
    hide_terminal "TERM_17"
    hide_terminal "TERM_25"
}
