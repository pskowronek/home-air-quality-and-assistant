#!/bin/bash

# Installation script for home-air-quality-and-assistant (https://github.com/pskowronek/home-air-quality-and-assistant)
# Does the following things:
# - installs raspbian (debian/ubuntu etc) packages required for the whole project
# - runs initialization and installation scripts for assistant (python modules and offline voice models)
# - optionally (after user's consent) copies services to /etc/systemd/system/
# - optionally (after user's consent) enables every each to start at boot time

VISUALIZER_JAR="https://github.com/rjaros87/pm-home-station/releases/download/1.3.0-alpha/pm-home-station-1.3.0-alpha.jar"

cd "$(dirname "$0")"

echo "Installation script of home-air-quality-and-assistant (https://github.com/pskowronek/home-air-quality-and-assistant)."
echo
echo "Script tested on Raspbian 'buster'. If you are using 'stretch' then you may consider upgrading to buster"
echo "(this instruction is quite nice: http://baddotrobot.com/blog/2019/08/29/upgrade-raspian-stretch-to-buster/)."
echo
read -p "Do you want to continue? (Y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "Bye!"
    exit 0
fi


echo "Going to update apt repository..."
sudo apt update

echo "Going to install required system libraries..."

# required by assistant
sudo apt install ar \
                 default-jre \
                 libpulse-dev \
                 portaudio19-dev \
                 python-pyaudio \
                 python3-pyaudio \
                 swig \
                 espeak \
                 wmctrl \
                 xdotool \
                 pv \
                 fortune \
                 xterm

echo "Finished with system libraries."

echo "Going to download pm-home-station jar to use it as the visualizer..."
rm -rf build
mkdir build
cd build
curl $VISUALIZER_JAR -L -O
cd -

echo "Going to copy a defulat pm-home-station config (res/pmhomestationconfig) to ~/.pmhomestationconfig..."
mv -f ~/.pmhomestationconfig ~/.pmhomestationconfig.BAK.$(date +%s) 2> /dev/null
cp res/pmhomestationconfig ~/.pmhomestationconfig


echo "Going to install python libraries and initialize acoustic model for athe assistant..."
assistant/install.sh

echo
if [[ $(pwd) != '/home/pi/home-air-quality-and-assistant' ]]
then
    echo "The directory where this script is present is different than '/home/pi/home-air-quality-and-assistant'."
    echo "If you want to use the current directory, then you must first edit *.service files and update the paths."
    echo
    read -p "Please confirm that *.service files have been updated and therefore you would like to continue. Do you confirm? (Y/N)  " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        echo "OK, please re-run this script when you updated *.service files or moved the project to /home/pi/home-air-quality-and-assistant"
        exit 0
    fi
fi

read -p "Do you want to copy services to /etc/systemd/system/ so you they can be enabled on boot in the next steps? (Y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    sudo cp *.service /etc/systemd/system/
    echo "Services have just been copied. You can start or enable/disable them anytime by invoking:"
    echo "sudo systemctl [start|enable|disable] [visualizer|brightness|assistant].service"
    echo

    read -p "Do you want to enable visualizer (Air Quality monitor) service to start on boot? (Y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo systemctl enable visualizer.service
    fi

    read -p "Do you want to enable brightness control service to start on boot? (Y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo systemctl enable brightness.service
    fi

    read -p "Do you want to enable voice assistant service to start on boot? (Y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        sudo systemctl enable assistant.service
    fi

fi
