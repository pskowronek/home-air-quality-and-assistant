#!/bin/bash

# This script simply starts pm-home-station in Kiosk mode.
# Run install.sh first to download pm-home-station jar to build/ directory (or do it
# manually - visit: https://github.com/rjaros87/pm-home-station/releases)

echo "Going to start pm-home-station..."
java -jar build/*.jar --kiosk
