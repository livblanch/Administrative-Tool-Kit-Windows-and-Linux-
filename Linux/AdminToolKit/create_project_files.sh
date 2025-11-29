#!/bin/bash

# Base directory
base="$HOME/Desktop/AdminToolKit/OrgData"

# Create directories
mkdir -p "$base/HR"
mkdir -p "$base/Finance"
mkdir -p "$base/IT"
mkdir -p "$base/Logs"
mkdir -p "$base/Backups"

# Create files
touch "$base/Logs/system_log1.txt"
touch "$base/Logs/system_log2.txt"
touch "$base/Finance/PayrollData.txt"
touch "$base/HR/Policies.docx"

echo "Directories and files created successfully."

