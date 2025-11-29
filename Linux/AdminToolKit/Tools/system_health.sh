#!/bin/bash

# ----------------------------------------
# System Health Report
# Generates CPU, RAM, Disk, and User info
# Exports to CSV
# ----------------------------------------

REPORT_DIR="$HOME/Desktop/AdminToolKit/Reports"
REPORT_FILE="$REPORT_DIR/system_health_$(date +%F).csv"

# Ensure report folder exists
mkdir -p "$REPORT_DIR"

# Header
echo "Date,Time,CPU_Usage(%),Memory_Usage(%),Disk_Usage(%),Active_Users" > "$REPORT_FILE"

# Gather metrics
DATE=$(date +%F)
TIME=$(date +%T)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print 100-$8}' | awk '{printf "%.2f",$1}')
MEM=$(free | grep Mem | awk '{printf "%.2f", $3/$2 * 100}')
DISK=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')
USERS=$(who | wc -l)

# Write to CSV
echo "$DATE,$TIME,$CPU,$MEM,$DISK,$USERS" >> "$REPORT_FILE"

echo "System health report generated at $REPORT_FILE"
