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

# /CONFIGURATION

echo "Going to start brightness control in 5s..."
# TODO Apparently sometimes we initialize too early and brightness control won't work - to be investigated later (something is overriding gpio pwm-ms?)
gpio -g mode $LCD_BRIGHTNESS_GPIO output
gpio -g write $LCD_BRIGHTNESS_GPIO 1
sleep 60s

# INIT
function clean_exit()
{
    echo "CTRL-C (SIGINT) caught - going to reset LCD to a default value and exit..."
    gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS_DEFAULT_VALUE
    exit
}
trap clean_exit SIGINT

LCD_BRIGHTNESS_PREV=$(( $LCD_BRIGHTNESS_DEFAULT_VALUE - 2 * $LCD_BRIGHTNESS_TRESHOLD ))

gpio -g mode $LCD_BRIGHTNESS_GPIO pwm
gpio pwm-ms
gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS_DEFAULT_VALUE

i2cset -r -y 1 $LUMI_SENSOR_ADDRESS 0x80 3 b
i2cset -r -y 1 $LUMI_SENSOR_ADDRESS 0x81 2 b
# /INIT

# Neverending story...
while true
do
    sleep $LOOP_ITER_SLEEP
    LUX=$(( $(i2cget -y 1 $LUMI_SENSOR_ADDRESS 0x8c w) )) # with hex to value conversion
    echo "Got data from lumi sensor - full spectrum (IR + Visible) is: $LUX lux"

    # Formula to calculate brightness taken from https://www.maximintegrated.com/en/design/technical-documents/app-notes/4/4913.html
    # remarks:
    # - doing "/1" to round to integer
    # - *1024/100 does mapping to range of PWM (0-1023)
    # - changed original formula to replace 27.059 with 0.1 - so it won't shine at night so much
    LCD_BRIGHTNESS=1023
    if (( $LUX <= 1254 )); then
        LCD_BRIGHTNESS=$( echo "scale=0; (( 9.9323*l( $LUX ) + 0.1 )*1023 / 100 )/1" | bc -l ) # " <- fix for mcedit syntax
    fi

    echo "Last LCD brightness was: $LCD_BRIGHTNESS_PREV, now it should be set to: $LCD_BRIGHTNESS"

    if (($LCD_BRIGHTNESS > $LCD_BRIGHTNESS_PREV + $LCD_BRIGHTNESS_TRESHOLD || $LCD_BRIGHTNESS < $LCD_BRIGHTNESS_PREV - $LCD_BRIGHTNESS_TRESHOLD)); then
        echo "Setting LCD brightness to reach $LCD_BRIGHTNESS..."
        for i in $(eval echo "{$LCD_BRIGHTNESS_PREV..$LCD_BRIGHTNESS..$LCD_BRIGHTNESS_STEP}")
        do
            echo -e "   $i -> $LCD_BRIGHTNESS"

            gpio -g pwm $LCD_BRIGHTNESS_GPIO $i
            #sleep 0.05s
        done
        # redo - sometimes something is changing the mode or what?
        gpio pwm-ms
        # set final value as the loop above could not reach the desired value due to step value
        gpio -g pwm $LCD_BRIGHTNESS_GPIO $LCD_BRIGHTNESS
    else
        echo "No need to adjust brightness - still within threshold"
    fi
    LCD_BRIGHTNESS_PREV=$LCD_BRIGHTNESS
done

