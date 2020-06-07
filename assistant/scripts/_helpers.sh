#!/bin/bash

# A set of helpers - not intended for direct execution

function brighten_display {
    BRIGHTNESS_PID=$(pgrep brightness.sh)
    kill -HUP $BRIGHTNESS_PID 
}

function brightness_normal {
    BRIGHTNESS_PID=$(pgrep brightness.sh)
    kill -CONT $BRIGHTNESS_PID 
}
