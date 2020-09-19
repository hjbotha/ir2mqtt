#! /bin/bash

#set -x

function log() {
  DATE=$(date "+%Y-%m-%d %H:%M:%S")
  echo "[$DATE] $@"
}

button=$1

#log "Received $button. Queueing publishing."

# FIFO method
#echo $1 > /ir2mqtt.fifo

# Single method
taskid=$(/usr/bin/tsp -f /handle_message.sh $button)
#log "Sent $button as job $taskid. Result:"
tsp -c $taskid
tsp -r $taskid
rm /tmp/ts-out.*
