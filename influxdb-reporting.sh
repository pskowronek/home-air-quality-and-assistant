#!/bin/bash

# This script is going to periodically send measurements to InfluxDB.

INFLUXDB_ADDR = "192.168.1.40"
INFLUXDB_USER = "user"
INFLUXDB_PASSWD = "changeme"

echo "Going to peridically trace /tmp/pm-home-station.csv to log data to InfluxDB..."
while true
do
    sleep 15m
    LAST=$(tail -1 /tmp/pm-home-station.csv)
    retVal=$?
    if [$retVal -eq 0]; then
        # TBD
    fi
done

