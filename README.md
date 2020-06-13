_Language versions:_\
[![EN](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-US.png)](https://github.com/pskowronek/home-air-quality-and-assistant) 
[![PL](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-PL.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=pl&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![DE](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-DE.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=de&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![FR](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-FR.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=fr&u=https://github.com/pskowronek/home-air-quality-and-assistant)
[![ES](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/flags/lang-ES.png)](https://translate.googleusercontent.com/translate_c?sl=en&tl=es&u=https://github.com/pskowronek/home-air-quality-and-assistant)

# Home Air Quality plus Voice Assistant

This is project is a result of Covid-19 lockdown :) Some references you can find on top of the final assembly (like the police hunting people going outside :>).
Basically, the project is to display in-door air quality metrics plus to give you a possibility to interact with the device using voice, akin to Alexa or Google Home - but offline :)

I'm not saying that it is any better than Alexa or Google Home - it isn't, but it is DIY :) The language model is very simple, the CPU of Raspberry Pi Zero ain't a king - it does what it
can to undestand the voice. The most important factor is a quality of USB soundcard and microphone.

So, to recap - I've started with a simple monitoring tool to display indoor air quality using PMS5003ST or PMS7003 sensors and Raspberry Pi Zero with Waveshare 3.5inch display... then things started to evolve :)

Finally the project includes three modules (services): visualizer, brightness and assistant.

BTW, it was a quite nice journey through electronics & soldering, bash scripting on beloved Linux, plus java (pm-home-station) & python.

## Visualizer

To visualize the sensor's air quality readings I used this project that I'm also a co-author: [pm-home-station](https://github.com/rjaros87/pm-home-station/).
It uses alpha build that supports small screen screens, Kiosk mode and PMS5003ST sensor that is able to measure formaldehyde concentration, humidity and temperature on top of pm2.5 and pm10 particles.

The visualizer displays:
- PM 1.0/2.5/10 readings + charts (PMS7003 and PMS5003ST)
- formaldehyde, humidity & temperature readings + charts (PMS5003ST)

## Brightness

To control Waveshare 3.5" display brightness I wrote a simple script to constantly adjust the brightness based on light sensor readings. The only trouble was that this LCD display does not support this
functionality OOB :) See [project's wiki](https://github.com/pskowronek/home-air-quality-and-assistant/wiki) how I hacked my way to add this functionality.

## Assistant

To display more information on this device I integrated a simple voice controlled assistant. It works offline even on RPi thanks to [PocketSphinx](https://github.com/cmusphinx/pocketsphinx).

Currently the assistant can be used to do the following things:
  - show weather and Moon details (thanks to [wttr.in](https://github.com/chubin/wttr.in) - awesome project btw)
  - tell some old jokes (using 'fortune' linux command)
  - display uptime
  - initiate reboot

The assistant itself can be easily reconfigured to understand additional commands - one must edit [config.yaml](https://github.com/pskowronek/home-air-quality-and-assistant/blob/master/assistant/config.yaml) and specialized [bash scripts](https://github.com/pskowronek/home-air-quality-and-assistant/tree/master/assistant/scripts) can be written to execute those commands.
A default configuration tries to react for two invocation words: [Cybill](https://en.wikipedia.org/wiki/Cybill_Shepherd) and [Bruce](https://en.wikipedia.org/wiki/Bruce_Willis) (we've got their posters on the wall behind, hence the idea for invocation words). This can also be easily reconfigured.
Each of the invocation words can have their voice adjusted, for example Cybill answers with a female voice, whereas Bruce with a male voice.

Some sample commands that are available out of the box:
  - Bruce, what is the weather like?
  - Cybill, what is the weather tomorrow?
  - Bruce, how is the Moon today?
  - Cybill, tell me a joke
  - Bruce, show me uptime
  - Cybill, reboot now

Of course voice recognition isn't perfect - a lot depends on soundcard & mike quality.

## Screenshots / Photos

### Screenshots

Some animated screenshots how it works when interacting with voice commands
![Screenshots](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/screenshots/screenshots.gif)


### Photos

[![Assembled](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/00.JPG)](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of the assembled home-air-quality-and-assistant")

More photos of how it was enclosed in a custom-built LEGO™ housing are [here](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of assembling home-air-quality-and-assistant").

*BTW, these LEGO bricks are almost 30 years old (!)*


## Hardware Requirements

- [Raspberry Pi Zero](https://botland.com.pl/en/modules-and-kits-raspberry-pi-is-zero/9749-raspberry-pi-zero-wh-512mb-ram-wifi-bt41-with-connectors.html) or similar
- [PMS7003](https://botland.com.pl/en/sensors-clean-air/10924-dust-air-clean-sensor-pms7003-33v-uart.html?search_query=PMS7003&results=6) or PMS5003ST sensors (the latter one is able to sense formaldehyde, temperature & humidity)
- [Waveshare 3.5" inch display for Raspberry Pi](https://botland.com.pl/en/displays-raspberry-pi/4479-touch-screen-a-resistive-lcd-35-320x480px-gpio-for-raspberry-pi-432bzero-waveshare-9904.html)
- [Hub USB hat](https://botland.com.pl/en/raspberry-pi-hat-extenders-findings/8870-hub-usb-hat-4-port-hub-for-raspberry-pi-4b3b3bzero-waveshare-12694.html)
- [Prototype board for RPi Zero](https://botland.com.pl/en/raspberry-pi-hat-extenders-findings/11714-breakout-pi-zero-prototype-board-for-raspberry-pi-zero-7426787870132.html)
- GY-2561 I2C light sensor to control the brightness thru GPIO PWM output via optocoupler and NPN transistor (see [wiki](https://github.com/pskowronek/home-air-quality-and-assistant/wiki))
- mini USB soundcard - try to find not the cheapest one, but rather a good quality one that has a good microphone signal (no noise etc)
- a mini microphone of decent quality
- a mini speaker (like MG15 0.1W 8ohm) plus amp [module](https://botland.com.pl/en/mp3-wav-oog-midi/6641-amplifier-audio-stereo-2x3w-5v-arduino-bascom-avr-green.html)
- 16GB SD card (as fast as possible due to voice assistant and its responsiveness)
- a [fan](https://botland.com.pl/en/fans/15056-fan-5v-30x30x10-mm-for-raspberry-pi-case.html) to cool down PMS5003ST laying close to LCD display, so it can read a real temperature (connected the fan to 3V so it is quiet and still does the job)

## Installation

- install [Raspbian Buster](https://www.raspberrypi.org/downloads/) on SD card using [this](https://www.raspberrypi.org/documentation/installation/installing-images/README.md) instruction
- enable and configure WiFi before you start the system - more [here](https://howchoo.com/g/ndy1zte2yjn/how-to-set-up-wifi-on-your-raspberry-pi-without-ethernet)
- find the IP of RPi by scanning your local network or take a look at your router to find a new device connected to your network
- SSH to your raspberry: ```ssh pi@10.20.30.40```
- install git: ```sudo apt install git```
- being in home directory issue the following command to fetch this project: ```git clone https://github.com/pskowronek/home-air-quality-and-assistant.git```
- go to the project directory: ```cd ~/home-air-quality-and-assistant``` and run the installer: ```./install.sh``` - this should hopefully walk you thru to install everything you need
  - if it fails then please try to analyze any error statements and follow instructions if provided
  - use Raspbian Buster. If you have Stretch then consider upgrading to Buster (quite good instructions are [here](http://baddotrobot.com/blog/2019/08/29/upgrade-raspian-stretch-to-buster/))
  - before you report a bug, try to google it first :)
- the installer above should ask you whether you want to register 3 services: visualizer, brightness, assistant (all of them are optional, for instance you can have the assistant without the other two).
This will let those services to be automatically run when Raspberry boots up (more details [here](https://www.raspberrypi.org/documentation/linux/usage/systemd.md))
  - verify if any given service works by invoking the following command(s):
    - ```sudo systemctl start visualizer.service```
    - ```sudo systemctl start brightness.service```
    - ```sudo systemctl start assistant.service```
  - reboot the device to verify if it works as expacted
  - logs can be observed by tracing /var/log/syslog: ```sudo tail -f /var/log/syslog```

## Tech details

The tech details can be found on [wiki](https://github.com/pskowronek/home-air-quality-and-assistant/wiki) page.

## License

This project is covered by Apache 2 license.

## Authors

- [Piotr Skowronek](https://github.com/pskowronek)

