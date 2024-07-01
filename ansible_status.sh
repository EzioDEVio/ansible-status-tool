#!/bin/bash

# Function to get IP address of the machine
get_ip() {
  hostname -I | awk '{print $1}'
}

# Function to get OS and Kernel info
get_os_kernel() {
  echo "$(lsb_release -d | awk -F"\t" '{print $2}'), Kernel: $(uname -r)"
}

# Colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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
echo -e "${CYAN}  _____       _         ____                _        "
echo -e " | ____| ____(_)  ___  |  _ \   ___ __   __(_)  ___  "
echo -e " |  _|  |_  /| | / _ \ | | | | / _ \\\\ \ / /| | / _ \ "
echo -e " | |___  / / | || (_) || |_| ||  __/ \ V / | || (_) |"
echo -e " |_____|/___||_| \___/ |____/  \___|  \_/  |_| \___/ ${NC}"
echo
echo -e "${GREEN}Control Machine:${NC}"
echo -e "${GREEN}Hostname:${NC} $CONTROL_HOSTNAME"
echo -e "${GREEN}IP Address:${NC} $CONTROL_IP"
echo -e "${GREEN}OS:${NC} $CONTROL_OS_KERNEL"
echo

# Managed Nodes Info
echo -e "${GREEN}Managed Nodes:${NC}"

# Extract nodes from inventory file
NODES=$(grep -vE '^\[|^$' "$INVENTORY_FILE")

for NODE in $NODES; do
  NODE_NAME=$(echo $NODE | cut -d' ' -f1)
  NODE_IP=$(echo $NODE | grep -oP '(?<=ansible_host=)[^\s]+')

  echo -e "${CYAN}Node:${NC} $NODE_NAME"
  echo -e "${CYAN}IP Address:${NC} $NODE_IP"

  # Check node status using Ansible ping module
  ansible -i "$INVENTORY_FILE" -m ping "$NODE_NAME" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo -e "${CYAN}Status:${NC} ${GREEN}SUCCESS${NC}"
  else
    echo -e "${CYAN}Status:${NC} ${RED}UNREACHABLE${NC}"
  fi
  echo
done
