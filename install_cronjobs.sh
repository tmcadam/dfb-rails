#!/bin/bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Runs at 0110 hrs on 1st day of each month
CRON_JOB="bash \"$PROJECT_DIR/monthly-backup.sh\""
if ! crontab -l | grep -q "$CRON_JOB"; then
    crontab -l > mycron
    echo "10 1 1 * * $CRON_JOB" >> mycron
    crontab mycron
    rm mycron
fi

# Runs at 0105 hrs daily
CRON_JOB="bash \"$PROJECT_DIR/daily-backup.sh\""
if ! crontab -l | grep -q "$CRON_JOB"; then
    crontab -l > mycron
    echo "5 1 * * * $CRON_JOB" >> mycron
    crontab mycron
    rm mycron
fi
