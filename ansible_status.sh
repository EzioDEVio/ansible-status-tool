#!/bin/bash

# Colors for output
GREEN="\033[0;32m"
CYAN="\033[0;36m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# Function to get control machine information
get_control_machine_info() {
    echo -e "${CYAN}Control Machine:${NC}"
    echo -e "${GREEN}Hostname:${NC} $(hostname)"
    echo -e "${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${GREEN}OS:${NC} $(lsb_release -d | awk -F"\t" '{print $2}')"
    echo -e "${GREEN}Kernel:${NC} $(uname -r)"
    echo
}

# Function to get managed nodes from inventory file
get_managed_nodes() {
    echo -e "${CYAN}Managed Nodes:${NC}"
    inventory_file="$1"

    if [ ! -f "$inventory_file" ]; then
        echo -e "${RED}Inventory file not found: $inventory_file${NC}"
        exit 1
    fi

    managed_nodes=$(grep -E '^[^\[#]' "$inventory_file" | awk '{print $1}')

    for node in $managed_nodes; do
        echo -e "${GREEN}Node:${NC} $node"
        ip=$(getent hosts "$node" | awk '{ print $1 }')
        echo -e "${GREEN}IP Address:${NC} $ip"
        echo -e "${GREEN}Status:${NC} $(ansible -m ping -i "$inventory_file" "$node" | grep -oP 'SUCCESS|UNREACHABLE')"
        echo
    done
}

# Main function to display all info
display_info() {
    inventory_file="$1"
    get_control_machine_info
    get_managed_nodes "$inventory_file"
}

# Check if inventory file is passed as argument
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <inventory_file>${NC}"
    exit 1
fi

# Run the main function
display_info "$1"
