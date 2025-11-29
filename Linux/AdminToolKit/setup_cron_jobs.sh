#!/bin/bash

# Install cron job for master automation
ROOT="$HOME/Desktop/AdminToolKit"

# Remove old cron jobs for this toolkit
crontab -l | grep -v "$ROOT/master_automation.sh" | crontab -

# Add new cron job at 2:45 PM daily
(
    crontab -l 2>/dev/null
    echo "45 14 * * * bash $ROOT/master_automation.sh >> $ROOT/RunLogs/master_cron.log 2>&1"
) | crontab -

echo "Master automation cron job installed for 2:45 PM daily."

