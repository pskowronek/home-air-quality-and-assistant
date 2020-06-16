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
It uses alpha build that supports small displays, Kiosk mode and PMS5003ST sensor that is able to measure formaldehyde concentration, humidity and temperature on top of pm2.5 and pm10 particles.

The visualizer displays:
- PM 1.0/2.5/10 readings + charts (PMS7003 and PMS5003ST)
- formaldehyde, humidity & temperature readings + charts (PMS5003ST)

## Brightness

To control Waveshare 3.5" display brightness I wrote a simple script to constantly adjust the brightness based on light sensor readings. The only trouble was that this LCD display does not support this
functionality OOB :) See [project's wiki](https://github.com/pskowronek/home-air-quality-and-assistant/wiki/Waveshare-3.5"-LCD-hack-for-backlight-control) how I hacked my way to add this functionality.

## Assistant

To display more information on this device I integrated a simple voice controlled assistant. It works offline even on RPi thanks to [PocketSphinx](https://github.com/cmusphinx/pocketsphinx).

Currently the assistant can be used to do the following things:
  - show weather and Moon details (thanks to [wttr.in](https://github.com/chubin/wttr.in) - awesome project btw)
  - tell some old jokes (using 'fortune' linux command)
  - display stocks value
  - display uptime
  - initiate reboot

The assistant itself can be easily reconfigured to understand additional commands - one must edit [config.yaml](https://github.com/pskowronek/home-air-quality-and-assistant/blob/master/assistant/config.yaml) and specialized [bash scripts](https://github.com/pskowronek/home-air-quality-and-assistant/tree/master/assistant/scripts) can be written to execute those commands.
A default configuration tries to react for two invocation sentences: Hey [Cybill](https://en.wikipedia.org/wiki/Cybill_Shepherd) and Hey [Bruce](https://en.wikipedia.org/wiki/Bruce_Willis) (we've got their posters on the wall behind, hence the idea for invocation words). This can also be easily reconfigured.
Each of the invocation words can have their voice adjusted, for example Cybill answers with a female voice, whereas Bruce with a male voice.

Some sample commands that are available out of the box:
  - Hey Bruce (...wait for ack sound...) what is the weather like?
  - Hey Cybill (...) what is the weather tomorrow?
  - Hey Bruce (...) how is the Moon today?
  - Hey Cybill (...) show my stocks
  - Hey Bruce (...) show me calendar
  - Hey Cybill (...) tell me a joke
  - Hey Bruce (...) show me uptime
  - Hey Cybill (...) reboot now

Of course voice recognition isn't perfect - a lot depends on soundcard & mike quality. Also, there are a lot of false positives for the invocation words (it wakes up while somebody is talking) - WiP :)

## Screenshots / Photos

### Screenshots

Some animated screenshots how it works when interacting with voice commands:

![Screenshots](https://github.com/pskowronek/home-air-quality-and-assistant/raw/master/www/screenshots/screenshots.gif)


### Photos

[![Assembled](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/00.JPG)](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of the assembled home-air-quality-and-assistant")

More photos of how it was enclosed in a custom-built LEGO™ housing are [here](https://pskowronek.github.io/home-air-quality-and-assistant/www/assembled/index.html "Photos of assembling home-air-quality-and-assistant").

*BTW, these LEGO bricks are almost 30 years old (!)*


## Hardware Requirements

See [wiki -> Hardware Requirements](https://github.com/pskowronek/home-air-quality-and-assistant/wiki/Hardware-Requirements) page.

## Installation

See [wiki -> Installation](https://github.com/pskowronek/home-air-quality-and-assistant/wiki/Installation) page.

## Tech details

See [wiki -> Scheme](https://github.com/pskowronek/home-air-quality-and-assistant/wiki/Schemes) page.

## License

This project is covered by Apache 2 license.

## Authors

- [Piotr Skowronek](https://github.com/pskowronek)

