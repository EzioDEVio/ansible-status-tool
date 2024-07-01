#!/bin/bash

# Function to print ASCII art logo
print_logo() {
    echo "      _    _               _        "
    echo "     / \  | |__   ___  ___| |_ __ _ "
    echo "    / _ \ | '_ \ / _ \/ __| __/ _\` |"
    echo "   / ___ \| | | |  __/ (__| || (_| |"
    echo "  /_/   \_\_| |_|\___|\___|\__\__,_|"
    echo
}

# Function to extract control machine details
get_control_machine_details() {
    echo "Control Machine:"
    echo "Hostname: $(hostname)"
    echo "IP Address: $(hostname -I | awk '{print $1}')"
    echo "OS: $(lsb_release -ds)"
    echo "Kernel: $(uname -r)"
    echo
}

# Function to extract managed nodes details
get_managed_nodes_details() {
    local inventory_file=$1
    echo "Managed Nodes:"
    grep -vE '^\s*$|^\s*#' "$inventory_file" | while IFS= read -r node; do
        if [[ -n $node ]]; then
            echo "Node: $node"
            ansible -m ping -i "$inventory_file" "$node" > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                echo "IP Address: $node"
                echo "Status: SUCCESS"
            else
                echo "IP Address: $node"
                echo "Status: FAILED"
            fi
            echo
        fi
    done
}

# Main script
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <inventory_file>"
    exit 1
fi

inventory_file=$1

print_logo
get_control_machine_details
get_managed_nodes_details "$inventory_file"
