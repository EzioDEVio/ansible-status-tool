#!/bin/bash

# Function to get IP address of the machine
get_ip() {
  hostname -I | awk '{print $1}'
}

# Function to get OS and Kernel info
get_os_kernel() {
  echo "$(lsb_release -d | awk -F"\t" '{print $2}'), Kernel: $(uname -r)"
}

# Check if inventory file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <inventory_file>"
  exit 1
fi

INVENTORY_FILE=$1

# Control Machine Info
CONTROL_HOSTNAME=$(hostname)
CONTROL_IP=$(get_ip)
CONTROL_OS_KERNEL=$(get_os_kernel)

# Print Control Machine Info
echo "  _____       _         ____                _        "
echo " | ____| ____(_)  ___  |  _ \   ___ __   __(_)  ___  "
echo " |  _|  |_  /| | / _ \ | | | | / _ \\\\ \ / /| | / _ \ "
echo " | |___  / / | || (_) || |_| ||  __/ \ V / | || (_) |"
echo " |_____|/___||_| \___/ |____/  \___|  \_/  |_| \___/ "
echo
echo "Control Machine:"
echo "Hostname: $CONTROL_HOSTNAME"
echo "IP Address: $CONTROL_IP"
echo "OS: $CONTROL_OS_KERNEL"
echo

# Managed Nodes Info
echo "Managed Nodes:"

# Extract nodes from inventory file
NODES=$(awk '/^\[/{flag=1; next} /^\]/{flag=0} flag' "$INVENTORY_FILE")

for NODE in $NODES; do
  NODE_NAME=$(echo $NODE | awk '{print $1}')
  NODE_IP=$(echo $NODE | awk '{print $2}')
  NODE_IP=${NODE_IP#*=}

  echo "Node: $NODE_NAME"
  echo "IP Address: $NODE_IP"

  # Check node status using Ansible ping module
  ansible -i "$INVENTORY_FILE" -m ping "$NODE_NAME" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "Status: SUCCESS"
  else
    echo "Status: UNREACHABLE"
  fi
  echo
done
