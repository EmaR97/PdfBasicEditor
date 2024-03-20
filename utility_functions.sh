#!/bin/bash

# Shared variable for logging
LOG_ENABLED=false

# Function for logging messages
log_message() {
    if [ "$LOG_ENABLED" = true ]; then
        echo "$1"
    fi
}

# Function for logging error messages in red
error_message() {
    echo -e "\e[31mError: $1\e[0m"
}

# Check if the '-l' option is present in the command-line arguments
check_log_option() {
    for arg in "$@"; do
        if [ "$arg" = "-l" ]; then
            LOG_ENABLED=true
            return
        fi
    done
}

# Call the check_log_option function with all command-line arguments
check_log_option "$@"
