#!/bin/bash


# Archive Logs Script - Linux/Bash Version
# Mirrors PowerShell ArchiveLogs.ps1 workflow


# CONFIGURATION

daysToKeep=7                                  # Logs older than this will be archived
base="$HOME/Desktop/AdminToolKit/OrgData"
logFolder="$base/Logs"
backupFolder="$base/Backups"
numLogs=10                                    # Total logs to create
backdateFirst=5                               # First N logs to backdate
backdateDays=8                                # Days to backdate

# 1. Ensure folders exist

mkdir -p "$logFolder"
mkdir -p "$backupFolder"

echo "Using log folder: $logFolder"
echo "Using backup folder: $backupFolder"
echo ""

# 2. Create logs

echo "Creating $numLogs log files..."
cd "$logFolder" || { echo "Cannot access $logFolder"; exit 1; }

for i in $(seq 1 $numLogs); do
    fileName="system_log$i.txt"
    echo "Log file $i created on $(date)" > "$fileName"
done

# Backdate first $backdateFirst logs
echo "Backdating first $backdateFirst logs by $backdateDays days..."
for i in $(seq 1 $backdateFirst); do
    touch -d "$backdateDays days ago" "system_log$i.txt"
done

echo "Log creation and backdating complete."
echo ""

# 3. Find old logs

echo "Finding logs older than $daysToKeep days..."
cutoff=$(date -d "-$daysToKeep days" +%s)

shopt -s nullglob
oldLogs=()
for log in "$logFolder"/*; do
    if [[ -f "$log" ]]; then
        modTime=$(date -r "$log" +%s)
        if (( modTime < cutoff )); then
            oldLogs+=("$log")
        fi
    fi
done

if [[ ${#oldLogs[@]} -eq 0 ]]; then
    echo "No logs older than $daysToKeep days to archive."
    exit 0
fi

# 4. Move old logs to backup

echo "Archiving old logs..."
for log in "${oldLogs[@]}"; do
    dest="$backupFolder/$(basename "$log")"
    if mv "$log" "$dest"; then
        echo "Moved $(basename "$log") to backup"
    else
        echo "Error moving $(basename "$log")"
    fi
done

echo "Log rotation complete!"
