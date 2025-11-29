#!/bin/bash

# Path to CSV
csvPath="$HOME/Desktop/AdminToolKit/Employees.csv"

# Default password (PAM strong)
defaultPassword="Str0ng!P@55w0rd#"

# Ensure CSV exists
if [[ ! -f "$csvPath" ]]; then
    echo "ERROR: CSV not found at $csvPath"
    exit 1
fi

# Extract header row and detect column positions
header=$(head -n 1 "$csvPath")

first_col=$(echo "$header" | awk -F',' '
{
    for (i=1; i<=NF; i++) {
        if (tolower($i)=="first name") print i
    }
}')

last_col=$(echo "$header" | awk -F',' '
{
    for (i=1; i<=NF; i++) {
        if (tolower($i)=="last name") print i
    }
}')

# Safety check
if [[ -z "$first_col" || -z "$last_col" ]]; then
    echo "ERROR: CSV missing 'First Name' or 'Last Name' headers."
    exit 1
fi

echo "Detected First Name column: $first_col"
echo "Detected Last Name column: $last_col"
echo "Processing users..."

# Process all rows after header
tail -n +2 "$csvPath" | \
while IFS=',' read -r line
do
    first=$(echo "$line" | awk -v col="$first_col" -F',' '{print $col}')
    last=$(echo "$line" | awk -v col="$last_col" -F',' '{print $col}')

    # Build username from first+last
    rawUsername=$(echo "${first}${last}" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    username="${rawUsername:0:20}"

    if id "$username" &>/dev/null; then
        echo "User exists: $username"
    else
        sudo useradd -m "$username" -c "$first $last"
        echo "${username}:${defaultPassword}" | sudo chpasswd
        echo "Created: $username"
    fi
done

echo "All users processed."

