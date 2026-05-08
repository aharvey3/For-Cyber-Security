#!/bin/bash
# monitor_failed_logins.sh - tails auth.log and alerts on failures

LOGFILE="/var/log/auth.log"
ALERT_EMAIL="admin@example.com"

tail -Fn0 "$LOGFILE" | while read line; do
    echo "$line" | grep -q "Failed password"
    if [ $? -eq 0 ]; then
        IP=$(echo "$line" | grep -oP 'from \K\d+\.\d+\.\d+\.\d+')
        echo "[ALERT] Failed SSH login from $IP at $(date)" >> /var/log/failmon.log
        # echo "Alert: $line" | mail -s "SSH Failure" "$ALERT_EMAIL"   # uncomment to send email
    fi
done
