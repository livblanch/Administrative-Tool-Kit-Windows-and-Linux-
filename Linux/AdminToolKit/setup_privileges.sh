#!/bin/bash

echo "=== Admin Toolkit Privilege Setup ==="

# Create the group if it doesn't exist
if ! getent group admintoolkit >/dev/null; then
    sudo groupadd admintoolkit
    echo "Created group: admintoolkit"
else
    echo "Group 'admintoolkit' already exists"
fi

# Add the current user to the group
sudo usermod -aG admintoolkit "$USER"
echo "Added $USER to admintoolkit group"

# Sudoers file path
sudoers_file="/etc/sudoers.d/admintoolkit"

echo "Configuring sudoers rules..."

# Create or overwrite allowed commands
sudo bash -c "cat > $sudoers_file" << 'EOF'
# AdminToolkit automated sudo rules
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/useradd
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/userdel
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/usermod
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/groupadd
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/groupdel
%admintoolkit ALL=(ALL) NOPASSWD: /usr/sbin/gpasswd
%admintoolkit ALL=(ALL) NOPASSWD: /usr/bin/chpasswd
%admintoolkit ALL=(ALL) NOPASSWD: /bin/mkdir
%admintoolkit ALL=(ALL) NOPASSWD: /bin/chown
%admintoolkit ALL=(ALL) NOPASSWD: /bin/chmod
EOF

# Fix permissions
sudo chmod 440 "$sudoers_file"

echo "Sudoers file configured successfully."

echo "=== COMPLETE ==="
echo "Log out and back in so your group membership applies."
echo "After that, ALL toolkit scripts will run without sudo password prompts."

