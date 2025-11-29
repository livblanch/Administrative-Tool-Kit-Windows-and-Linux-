#!/bin/bash

# Path to terminated users CSV
csvPath="$HOME/Desktop/AdminToolKit/TerminatedUsers.csv"

# Ensure CSV exists
if [[ ! -f "$csvPath" ]]; then
    echo "TerminatedUsers.csv not found. Exiting."
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

if [[ -z "$first_col" || -z "$last_col" ]]; then
    echo "ERROR: CSV missing 'First Name' or 'Last Name' headers."
    exit 1
fi

echo "Detected First Name column: $first_col"
echo "Detected Last Name column: $last_col"
echo "Processing terminated users..."

# Process all rows after header
tail -n +2 "$csvPath" | while IFS=',' read -r line
do
    first=$(echo "$line" | awk -v col="$first_col" -F',' '{print $col}')
    last=$(echo "$line" | awk -v col="$last_col" -F',' '{print $col}')

    # Build username EXACTLY like create_users.sh
    rawUsername=$(echo "${first}${last}" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    username="${rawUsername:0:20}"

    # Delete user if exists
    if id "$username" &>/dev/null; then
        sudo userdel -r "$username"
        echo "Deleted terminated user: $username"
    else
        echo "User not found: $username"
    fi
done

echo "All terminated users processed."

