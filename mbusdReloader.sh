#!/bin/bash

get_timestamp() {
    date +"[%Y-%m-%d %H:%M:%S]"
}

# The service to be monitored
SERVICE="mbusd@ttyS0"
LOG_FILE="/root/mbusdreload.log"

# Function to log messages with timestamps
log_message() {
    local message="$1"
    echo -e "\n $(get_timestamp) - $message" | tee -a "$LOG_FILE"
}

# Function to restart the service
restart_service() {
    sleep 1
    log_message "Failed detected. Restarting $SERVICE..."
    systemctl restart $SERVICE
    sleep 5
    if [ $? -eq 0 ]; then
        log_message "$SERVICE restarted successfully."
        log_message "Journalctl logs after restarted:"
        journalctl -u $SERVICE --since '3 sec ago' | tee -a "$LOG_FILE"
        sleep 50
    else
        log_message "Failed to restart $SERVICE."
    fi
}

# Redirect all output to log file with timestamps
exec > >(while read line; do echo "$(get_timestamp) $line"; done | tee -a "$LOG_FILE") 2>&1

# Infinite loop to monitor the logs and restart service on specific log message
while true; do
    if journalctl -u $SERVICE --since '50 sec ago' | grep 'Stopped Modbus'; then
        restart_service
    fi
    sleep 5  # Sleep for a few seconds before checking again
done
