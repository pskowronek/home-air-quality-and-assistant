#!/bin/bash

# CONFIGURATION

# Tested with TSL2561
LUMI_SENSOR_ADDRESS="0x39"
# GPIO PIN number where LCD brightness can be controlled (BCM_GPIO pins numbers, not RPi wiring pins!)
LCD_BRIGHTNESS_GPIO="12"
# A default init value for LCD brightness (0 means to fade-in from black)
LCD_BRIGHTNESS_DEFAULT_VALUE="0"
# Step value while changing the brightness gradually
LCD_BRIGHTNESS_STEP=10
# Time between lumi checks (format as for sleep command, see 'man sleep')
LOOP_ITER_SLEEP="0.5s"
# Trigger brightness change only if it changed by this value (in normalized range of 0-1023)
LCD_BRIGHTNESS_TRESHOLD=5
# The number of loop iterations the forced brightness should exist (120 * LOOP_ITER_SLEEP ~= 1m)
FORCED_BRIGHTNESS_LOOP_COUNT=120
# Delay before starting to operate (by using After graphical.target it's not so required to wait too much anymore, but still...)
START_DELAY=30s

# /CONFIGURATION

echo "Going to start brightness control in $START_DELAY..."
# TODO Apparently sometimes we initialize too early and brightness control won't work - to be investigated later (something is overriding gpio pwm-ms?)
gpio -g mode $LCD_BRIGHTNESS_GPIO output
gpio -g write $LCD_BRIGHTNESS_GPIO 1
# notify systemd watchdog
systemd-notify --status="started, waiting $START_DELAY to start"
sleep $START_DELAY

# INIT
function clean_exit()
{
    echo "CTRL-C (SIGINT) caught - going to reset LCD to a default value and exit..."
    gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS_DEFAULT_VALUE
    exit
}
FORCED_BRIGHTNESS=0
trap clean_exit SIGINT
trap ' FORCED_BRIGHTNESS=$FORCED_BRIGHTNESS_LOOP_COUNT; echo "Requested forced brightness" ' SIGHUP
trap ' FORCED_BRIGHTNESS=0; echo "Requested the end of forced brightness" ' SIGCONT


LCD_BRIGHTNESS_PREV=$(( $LCD_BRIGHTNESS_DEFAULT_VALUE - 2 * $LCD_BRIGHTNESS_TRESHOLD ))
LCD_BRIGHTNESS=0

gpio -g mode $LCD_BRIGHTNESS_GPIO pwm
gpio pwm-ms
gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS_DEFAULT_VALUE

i2cset -r -y 1 $LUMI_SENSOR_ADDRESS 0x80 3 b
i2cset -r -y 1 $LUMI_SENSOR_ADDRESS 0x81 2 b
# /INIT

systemd-notify --ready --status="ready and operating..."

# Neverending story...
while true
do
    systemd-notify WATCHDOG=1 --status="operating..."
    sleep $LOOP_ITER_SLEEP
    # Forced brightness controlled by HUP signal
    if (( $FORCED_BRIGHTNESS == $FORCED_BRIGHTNESS_LOOP_COUNT )); then
        FORCED_BRIGHTNESS=$(( $FORCED_BRIGHTNESS - 1 ))
        LCD_BRIGHTNESS=$(( $LCD_BRIGHTNESS_PREV * 3 ))
        # Override prev to lower number of increments (to save time and CPU)
        if (( $LCD_BRIGHTNESS > 1023 )); then
            LCD_BRIGHTNESS=1023
        fi
        LCD_BRIGHTNESS_PREV=$(( $LCD_BRIGHTNESS - $LCD_BRIGHTNESS_TRESHOLD -1 ))
        echo "Forcing brightness 3 times (up to 100% of LCD brightness) as requested"
    elif (( $FORCED_BRIGHTNESS > 0 )); then
        FORCED_BRIGHTNESS=$(( $FORCED_BRIGHTNESS - 1 ))
        echo "Forced brightness, counting down to normal operation: $FORCED_BRIGHTNESS -> 0"
    # Normal operation
    else
        LUX=$(( $(i2cget -y 1 $LUMI_SENSOR_ADDRESS 0x8c w) )) # with hex to value conversion
        #echo "Got data from lumi sensor - full spectrum (IR + Visible) is: $LUX lux"  # don't spam syslog too much :)
        # Formula to calculate brightness taken from https://www.maximintegrated.com/en/design/technical-documents/app-notes/4/4913.html
        # remarks:
        # - doing "/1" to round to integer
        # - *1024/100 does mapping to range of PWM (0-1023)
        # - changed original formula to replace 27.059 with 0.1 - so it won't shine at night so much
        LCD_BRIGHTNESS=1023
        if (( $LUX <= 1254 )); then
            LCD_BRIGHTNESS=$( echo "scale=0; (( 9.9323*l( $LUX ) + 0.1 )*1023 / 100 )/1" | bc -l ) # " <- fix for mcedit syntax
        fi
    fi

    #echo "Last LCD brightness was: $LCD_BRIGHTNESS_PREV, now it should be set to: $LCD_BRIGHTNESS"  # don't spam syslog too much :)

    if (($LCD_BRIGHTNESS > $LCD_BRIGHTNESS_PREV + $LCD_BRIGHTNESS_TRESHOLD || $LCD_BRIGHTNESS < $LCD_BRIGHTNESS_PREV - $LCD_BRIGHTNESS_TRESHOLD)); then
        echo "Setting LCD brightness to reach $LCD_BRIGHTNESS..."
        for i in $(eval echo "{$LCD_BRIGHTNESS_PREV..$LCD_BRIGHTNESS..$LCD_BRIGHTNESS_STEP}")
        do
            echo -e "   $i -> $LCD_BRIGHTNESS"
            gpio -g pwm $LCD_BRIGHTNESS_GPIO $i
        done
        # redo - sometimes something is changing the mode or what?
        gpio pwm-ms
        # set final value as the loop above could not reach the desired value due to step value
        gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS
    #else
        #echo "No need to adjust brightness - still within threshold"  # dont' spam syslog too much :)
    fi
    LCD_BRIGHTNESS_PREV=$LCD_BRIGHTNESS
done

