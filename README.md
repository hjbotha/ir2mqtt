# ir2mqtt

ir2mqtt is a Home Assistant addon which takes button keypresses from an MCE remote (or a universal remote such as Logitech Harmony pretending to be an MCE remote) and sends each pressed button as an MQTT payload on the configured topic.

ir2mqtt was built on/for the following. Variations may require adjustments.
- Home Assistant on a Raspberry Pi (developed and tested on RPi 4b)
- GPIO IR receiver

## Requirements
- Home Assistant on a Raspberry Pi (only tested with 4b, but other versions should work)
- MQTT addon

## Installation

To enable the IR receiver:
- Edit /mnt/boot/config.txt on your Raspberry Pi 4 running Home Assistant
  - Enable SSH on the Home Assistant host, or insert the SD card into another system and mount the boot partition
- Add the following line:
```
dtoverlay=gpio-ir,gpio_pin=4
```
- (Note: gpio_pin should be set to the number of the GPIO pin to which the IR receiver is connected. This is not necessarily the same as the number of the physical pin.)

To install ir2mqtt:
- Enable the Samba addon in Home Assistant and go to \\home_assistant\addons where home_assistant is your Home Assistant host name/IP address
- Clone this repository to the addons share
- Go to the Home Assistant Add-on Store page
- Click on the menu button (top right corner) and click Reload
- Click on ir2mqtt which should show up at the top of the Add-On Store page, under "Local add-ons"
- Click Install. This will take a few minutes. The supervisor log will show any errors.
- After installing ir2mqtt, click on the Configuration tab
- Provide the username and password to use to connect to the MQTT broker, and the topic to which button presses should be published
- Start the add-on, and enable it to start at boot

## Usage

Pressing a button on an MCEUSB remote which reaches the IR sensor should result in the name of that button being sent to the MQTT topic defined in the configuration.

All button presses will be logged to the add-on log page, so you can verify that button presses are being received. Any MQTT publishing errors would also be shown here.

Not all button presses will currently be forwarded. The current full list is in the irexec.lircrc file. Other buttons can be identified by looking through the mceusb.conf file or by running irw in the container.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
