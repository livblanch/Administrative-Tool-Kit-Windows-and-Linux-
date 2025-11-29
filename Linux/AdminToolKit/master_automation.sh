#!/bin/bash

#######################################################
# Master Automation for AdminToolkit (Linux)
# Runs all scripts, logs output, and zips daily report
#######################################################

# Paths
ROOT="$HOME/Desktop/AdminToolKit"
LOG_FOLDER="$ROOT/RunLogs"
SUMMARY_FOLDER="$ROOT/DailySummaries"

mkdir -p "$LOG_FOLDER" "$SUMMARY_FOLDER"

# Timestamp
TIMESTAMP=$(date +%F_%H-%M-%S)
declare -A ERRORS
SUMMARY_LOG="$SUMMARY_FOLDER/Summary_$TIMESTAMP.txt"

# List of scripts in order
declare -A SCRIPTS=(
    ["BulkCreateUsers"]="$ROOT/create_users.sh"
    ["BulkDeleteUsers"]="$ROOT/bulk_delete_users.sh"
    ["BulkAssignDepartments"]="$ROOT/create_users_departments.sh"
    ["CreateProjectFiles"]="$ROOT/create_project_files.sh"
    ["ArchiveOldLogs"]="$ROOT/log_manager.sh"
    ["CompressBackup"]="$ROOT/backup_orgdata.sh"
    ["SystemHealthChecks"]="$ROOT/system_health.sh"
)

# Function to run a script
run_script() {
    local name=$1
    local path=$2
    local log="$LOG_FOLDER/${name}_$TIMESTAMP.log"

    echo "Running $name..."
    bash "$path" &> "$log"
    if [[ $? -ne 0 ]]; then
        ERRORS["$name"]="Exited with error. See $log"
    fi
}

# Execute each script
for task in "${!SCRIPTS[@]}"; do
    run_script "$task" "${SCRIPTS[$task]}"
done

# Build summary
{
    echo "Daily Status Summary - $TIMESTAMP"
    echo "===================================="
    for task in "${!SCRIPTS[@]}"; do
        if [[ -n "${ERRORS[$task]}" ]]; then
            echo "[FAILED] $task"
            echo "Reason: ${ERRORS[$task]}"
        else
            echo "[SUCCESS] $task"
        fi
        echo ""
    done
} > "$SUMMARY_LOG"

echo "Summary created: $SUMMARY_LOG"

# Zip logs + summary
ZIP_FILE="$ROOT/DailyReport_$TIMESTAMP.zip"
zip -j "$ZIP_FILE" "$SUMMARY_LOG" "$LOG_FOLDER/"*"$TIMESTAMP".log

echo "Created master ZIP archive: $ZIP_FILE"

