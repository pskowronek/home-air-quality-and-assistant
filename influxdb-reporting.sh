#!/bin/bash

# This script is going to periodically send measurements to InfluxDB.

INFLUXDB_ADDR="192.168.1.40:8086"
INFLUXDB_USER="user"
INFLUXDB_PASSWD="changeme"
INFLUXDB_NAME="sensors"
INFLUXDB_ROW="readings"

NODE_NAME="saloon"

echo "Going to periodically trace /tmp/pm-home-station.csv to log data to InfluxDB..."
while true
do
    sleep 15m
    check=$(ls /tmp/pm-home-station.csv)
    retVal=$?
    if [ $retVal -eq 0 ]; then
        echo "Got some latest readings!"
        tail -1 /tmp/pm-home-station.csv |
          while IFS=, read -r datetime pm1 pm25 pm10 hcho humi temp
          do
            echo "Going to send data to InfluxDB under $INFLUXDB_ADDR..."
            curl -i -XPOST "http://$INFLUXDB_ADDR/write?db=$INFLUXDB_NAME&u=$INFLUXDB_USER&p=$INFLUXDB_PASSWD" --data-binary "$INFLUXDB_ROW,name=$NODE_NAME pm1=$pm1,pm25=$pm25,pm10=$pm10,hcho=$hcho,humidity=$humi,temp=$temp"
          done
    fi
done
