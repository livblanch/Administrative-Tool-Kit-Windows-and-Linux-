#!/bin/bash

# ----------------------------------------
# Backup OrgData folder
# Compresses OrgData to Backups
# ----------------------------------------

ORG_DIR="$HOME/Desktop/AdminToolKit/OrgData"
BACKUP_DIR="$HOME/Desktop/AdminToolKit/Backups"
TIMESTAMP=$(date +%F_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/OrgData_backup_$TIMESTAMP.tar.gz"

# Ensure backup folder exists
mkdir -p "$BACKUP_DIR"

# Compress OrgData
if [[ -d "$ORG_DIR" ]]; then
    tar -czf "$BACKUP_FILE" -C "$ORG_DIR" .
    echo "OrgData backup completed: $BACKUP_FILE"
else
    echo "ERROR: OrgData folder does not exist at $ORG_DIR"
    exit 1
fi
