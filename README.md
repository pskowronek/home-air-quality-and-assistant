_Language versions:_\
[![EN](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-US.png)](https://github.com/pskowronek/home-air-quality-and-assistant) 
[![PL](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-PL.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=pl&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![DE](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-DE.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=de&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![FR](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-FR.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=fr&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![ES](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-ES.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=es&u=https://github.com/pskowronek/home-air-quality-and-assistant)

# Home Air Quality plus Voice Assistant

This is project is a result of Covid-19 lockdown :)
I've start with a simple monitoring tool to display in-door air quality using PMS5003ST or PMS7003 sensors and Raspberry Pi Zero with Waveshare 3.5inch display. Then things started to evolve :)
Finally, the project includes:
- a visualizer to display air quality readings - for this I use this project (that I'm also a co-author): [pm-home-station](https://github.com/rjaros87/pm-home-station/) - it uses alpha build that supports kiosk mode and PMS5003ST
- a brightness service to control the Waveshare 3.5" display brightness, FYI this LCD display does not support this functionality OOB (see wiki how I hacked my way to add this functionality)
- a voice assistant service that works offline by using [PocketSphinx](https://github.com/cmusphinx/pocketsphinx) to:
  - display weather and Moon details (thanks to [wttr.in](https://github.com/chubin/wttr.in) - awesome project btw)
  - tell some old jokes (using 'fortune' linux command)
  - state uptime
  - initiate reboot

## Screenshots / Photos

### Screenshots
![Screenshots](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/screenshots/screenshots.gif)


### Photos
[![Assembled](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/01.JPG)](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of the assembled home-air-quality-and-assistant")

More photos of the assembled project enclosed in a custom-built LEGO™ housing are [here](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of assembled home-air-quality-and-assistant").

*BTW, these LEGO bricks are almost 30 years old (!)*


## Hardware Requirements

- [Raspberry Pi Zero](https://botland.com.pl/en/modules-and-kits-raspberry-pi-is-zero/9749-raspberry-pi-zero-wh-512mb-ram-wifi-bt41-with-connectors.html) or similar
- [PMS7003](https://botland.com.pl/en/sensors-clean-air/10924-dust-air-clean-sensor-pms7003-33v-uart.html?search_query=PMS7003&results=6) or PMS5003ST sensors (the latter one is able to sense formaldehyde, temperature & humidity)
- [Waveshare 3.5" inch display for Raspberry Pi](https://botland.com.pl/en/displays-raspberry-pi/4479-touch-screen-a-resistive-lcd-35-320x480px-gpio-for-raspberry-pi-432bzero-waveshare-9904.html)
- [USB hub hat](https://botland.com.pl/en/raspberry-pi-hat-extenders-findings/8870-hub-usb-hat-4-port-hub-for-raspberry-pi-4b3b3bzero-waveshare-12694.html)
- mini usb soundcard - try to find not the cheapest ones, but rather of good quality to have good microphone input (no noise etc)
- a mini microphone
- a mini speaker (like MG15 0.1W 8ohm) plus amp [module](https://botland.com.pl/en/mp3-wav-oog-midi/6641-amplifier-audio-stereo-2x3w-5v-arduino-bascom-avr-green.html)
- 16GB SD card (as fast as possible due to voice assistant and responsiveness)

## Installation

- install [Raspbian Buster](https://www.raspberrypi.org/downloads/) on SD card using [this](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) instruction
- enable and configure WiFi before you start the system - more [here](https://howchoo.com/g/ndy1zte2yjn/how-to-set-up-wifi-on-your-raspberry-pi-without-ethernet)
- find the IP of RPi by scanning your local network or take a look at your router to find a new device connected to your network
- SSH to your raspberry: ```ssh pi@10.20.30.40```
- install git: ```sudo apt install git```
- issue the command to fetch this project: ```git clone https://github.com/pskowronek/home-air-quality-and-assistant.git```
- go to the project directory: ```cd home-air-quality-and-assistant``` and run the automatic installer: ```./install.sh``` - this should hopefully install everything you need
  - if it fails then please try to analyze any error statements and follow instructions if provided
  - use Raspbian Buster, if you have Stretch the consider upgrading (a good instructions are [here](http://baddotrobot.com/blog/2019/08/29/upgrade-raspian-stretch-to-buster/))
  - before you report a bug, try to google it first :)
- The installer above should ask you whether you want to register 3 services: visualizer, brightness, assistant (brightness is optional if don't have LCD display that supports this).
This will let those service to automatically run when Raspberry boots up (more details [here](https://www.raspberrypi.org/documentation/linux/usage/systemd.md))
  - verify if service works by invoking the following commands:
    - ```sudo systemctl start visualizer.service```
    - ```sudo systemctl start brightness.service```
    - ```sudo systemctl start assistant.service```
  - reboot device to verify if it works
  - logs can be observed in /var/log/syslog: ```sudo tail -f /var/log/syslog```

## Tech details


## License

Thie project is covered by Apache 2 license.

## Authors

- [Piotr Skowronek](https://github.com/pskowronek)

