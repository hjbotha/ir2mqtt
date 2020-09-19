#!/bin/bash

function log() {
    DATE=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$DATE] $1"
}

# Set number of jobs task-spooler wil run at a time
tsp -S 1

# The FIFO method proved unreliable, sadly. Leaving the capability but not using it. Edit queue_message_and_show_output.sh and uncomment this paragraph to enable it.
#log "Creating FIFO"
#mkfifo /ir2mqtt.fifo

log "Getting config options"
CONFIG_PATH=/data/options.json
MQTT_USERNAME="$(jq --raw-output '.mqttUsername' $CONFIG_PATH)"
MQTT_PASSWORD="$(jq --raw-output '.mqttPassword' $CONFIG_PATH)"
MQTT_TOPIC="$(jq --raw-output '.mqttTopic' $CONFIG_PATH)"

cat /handle_message.sh.template | sed "s~__MQTT_TOPIC__~$MQTT_TOPIC~" | sed "s~__MQTT_USERNAME__~$MQTT_USERNAME~" | sed "s~__MQTT_PASSWORD__~$MQTT_PASSWORD~" >/handle_message.sh
chmod a+x /handle_message.sh

log "Starting lircd"
service lircd start >/dev/null

log "Starting irexec"
irexec /etc/lirc/irexec.lircrc &

# The FIFO method proved unreliable, sadly. Leaving the capability but not using it. Edit queue_message_and_show_output.sh and uncomment this paragraph to enable it.
#log "Starting FIFO monitoring and MQTT publishing"
#tail -f /ir2mqtt.fifo | mosquitto_pub -d -t $MQTT_TOPIC -u $MQTT_USERNAME -P $MQTT_PASSWORD -h homeassistant -l -i ir2mqtt &
#mosquitto_pub_pid=$(pidof mosquitto_pub)

log "Monitoring processes every 60 seconds"
sleep 60

while true; do
    log "Checking processes"
    if ! pidof irexec >/dev/null; then
        log "irexec died. Restarting."
        irexec /etc/lirc/irexec.lircrc &
    fi
    if ! pidof lircd >/dev/null; then
        log "lircd died. Restarting."
        service lircd start
    fi
# The FIFO method proved unreliable, sadly. Leaving the capability but not using it. Edit queue_message_and_show_output.sh and uncomment this section to enable it.
#    if ! pidof mosquitto_pub >/dev/null; then
#        log "mosquitto_pub died. Restarting."
#        tail -f /ir2mqtt.fifo | mosquitto_pub -d -t $MQTT_TOPIC -u $MQTT_USERNAME -P $MQTT_PASSWORD -h homeassistant -l -i ir2mqtt &
#        sleep 1
#    elif ! netstat -nap | grep " $mosquitto_pub_pid/mosquitto_pub$" > /dev/null; then
#        log "mosquitto_pub running but not connected. Restarting."
#        kill $mosquitto_pub_pid
#        tail -f /ir2mqtt.fifo | mosquitto_pub -d -t $MQTT_TOPIC -u $MQTT_USERNAME -P $MQTT_PASSWORD -h homeassistant -l -i ir2mqtt &
#    fi
    sleep 60
done
