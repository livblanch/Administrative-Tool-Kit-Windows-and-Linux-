#!/bin/bash

# Path to CSV
csvPath="$HOME/Desktop/AdminToolKit/Employees.csv"

# Default password
defaultPassword="Str0ng!P@55w0rd#"

# Ensure CSV exists
if [[ ! -f "$csvPath" ]]; then
    echo "ERROR: CSV not found at $csvPath"
    exit 1
fi

####################################################
# 1. DYNAMICALLY DETECT COLUMN POSITIONS
####################################################
header=$(head -n 1 "$csvPath")

first_col=$(echo "$header" | awk -F',' '{for (i=1;i<=NF;i++) if(tolower($i)=="first name") print i}')
last_col=$(echo "$header"  | awk -F',' '{for (i=1;i<=NF;i++) if(tolower($i)=="last name") print i}')
dept_col=$(echo "$header"  | awk -F',' '{for (i=1;i<=NF;i++) if(tolower($i)=="department") print i}')

if [[ -z "$first_col" || -z "$last_col" || -z "$dept_col" ]]; then
    echo "ERROR: CSV missing required headers."
    exit 1
fi

echo "Detected First Name column: $first_col"
echo "Detected Last Name column: $last_col"
echo "Detected Department column: $dept_col"
echo "Processing users..."
echo ""

####################################################
# 2. CREATE UNIQUE DEPARTMENT GROUPS
####################################################
echo "Creating department groups..."

# Extract unique departments using while loop
tail -n +2 "$csvPath" | awk -v col="$dept_col" -F',' '{print $col}' | sort -u | while read -r dept; do
    # Replace spaces with underscores and remove invalid chars
    cleanDept=$(echo "$dept" | sed 's/[\\\/:*?"<>|]/_/g' | tr ' ' '_')

    if ! getent group "$cleanDept" >/dev/null; then
        sudo groupadd "$cleanDept"
        echo "Created group: $dept (Linux name: $cleanDept)"
    else
        echo "Group already exists: $dept (Linux name: $cleanDept)"
    fi
done

echo ""

####################################################
# 3. CREATE USERS AND ADD TO GROUPS
####################################################
echo "Creating users and assigning groups..."

tail -n +2 "$csvPath" | while IFS=',' read -r line; do
    first=$(echo "$line" | awk -v col="$first_col" -F',' '{print $col}')
    last=$(echo "$line" | awk -v col="$last_col" -F',' '{print $col}')
    dept=$(echo "$line" | awk -v col="$dept_col" -F',' '{print $col}')

    # Build username (first+last, lowercase, no spaces, max 20 chars)
    rawUsername=$(echo "${first}${last}" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
    username="${rawUsername:0:20}"

    # Create user if missing
    if ! id "$username" &>/dev/null; then
        sudo useradd -m "$username" -c "$first $last"
        echo "${username}:${defaultPassword}" | sudo chpasswd
        echo "Created user: $username"
    else
        echo "User already exists: $username"
    fi

    # Assign user to department group
    cleanDept=$(echo "$dept" | sed 's/[\\\/:*?"<>|]/_/g' | tr ' ' '_')
    sudo usermod -aG "$cleanDept" "$username"
    echo "Added $username to group: $dept (Linux name: $cleanDept)"
    echo ""
done

echo "All users processed."

