#!/bin/bash

# Function to fetch node details
get_node_details() {
    local node=$1
    local details=""
    details+="OS: $(ansible -i $inventory_file -m setup -a 'filter=ansible_distribution*' $node | grep ansible_distribution | awk -F": " '{print $2}' | xargs)\n"
    details+="Host: $(ansible -i $inventory_file -m setup -a 'filter=ansible_hostname' $node | grep ansible_hostname | awk -F": " '{print $2}' | xargs)\n"
    details+="Kernel: $(ansible -i $inventory_file -m setup -a 'filter=ansible_kernel' $node | grep ansible_kernel | awk -F": " '{print $2}' | xargs)\n"
    details+="Uptime: $(ansible -i $inventory_file -m command -a 'uptime -p' $node | grep uptime | awk -F": " '{print $2}' | xargs)\n"
    details+="Packages: $(ansible -i $inventory_file -m command -a 'rpm -qa | wc -l' $node | grep stdout | awk -F": " '{print $2}' | xargs) (rpm)\n"
    details+="Shell: $(ansible -i $inventory_file -m setup -a 'filter=ansible_env.SHELL' $node | grep ansible_env.SHELL | awk -F": " '{print $2}' | xargs)\n"
    details+="Resolution: preferred\n"
    details+="Terminal: $(ansible -i $inventory_file -m setup -a 'filter=ansible_env.TERM' $node | grep ansible_env.TERM | awk -F": " '{print $2}' | xargs)\n"
    details+="CPU: $(ansible -i $inventory_file -m setup -a 'filter=ansible_processor' $node | grep ansible_processor | grep -v ansible_processor_vcpus | grep -v ansible_processor_cores | awk -F": " '{print $2}' | xargs)\n"
    details+="Memory: $(ansible -i $inventory_file -m setup -a 'filter=ansible_memory_mb' $node | grep ansible_memory_mb.real | awk '{print $2"MiB / "$4"MiB"}')\n"
    details+="IP Address: $(ansible -i $inventory_file -m setup -a 'filter=ansible_default_ipv4.address' $node | grep ansible_default_ipv4.address | awk -F": " '{print $2}' | xargs)\n"
    echo -e $details
}

# Check if inventory file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <inventory_file>"
    exit 1
fi

inventory_file=$1

# Get control machine information
control_hostname=$(hostname)
control_ip=$(hostname -I | awk '{print $1}')
control_os=$(lsb_release -d | awk -F"\t" '{print $2}')
control_kernel=$(uname -r)
control_uptime=$(uptime -p)
control_packages=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
control_shell=$SHELL
control_resolution=$(xdpyinfo | grep dimensions | awk '{print $2}')
control_terminal=$TERM
control_cpu=$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)
control_memory=$(free -m | awk 'NR==2{printf "%sMiB / %sMiB\n", $3,$2 }')

# Add color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Display control machine information
cat << "EOF"
  _____       _         ____                _        
 | ____| ____(_)  ___  |  _ \   ___ __   __(_)  ___  
 |  _|  |_  /| | / _ \ | | | | / _ \ \ / /| | / _ \ 
 | |___  / / | || (_) || |_| ||  __/ \ V / | || (_) |
 |_____|/___||_| \___/ |____/  \___|  \_/  |_| \___/ 
EOF

echo -e "${BLUE}Control Node: $control_hostname.localdomain${NC}\n----------------------------"
echo -e "${GREEN}OS:${NC} $control_os"
echo -e "${GREEN}Host:${NC} $control_hostname"
echo -e "${GREEN}Kernel:${NC} $control_kernel"
echo -e "${GREEN}Uptime:${NC} $control_uptime"
echo -e "${GREEN}Packages:${NC} $control_packages"
echo -e "${GREEN}Shell:${NC} $control_shell"
echo -e "${GREEN}Resolution:${NC} $control_resolution"
echo -e "${GREEN}Terminal:${NC} $control_terminal"
echo -e "${GREEN}CPU:${NC} $control_cpu"
echo -e "${GREEN}Memory:${NC} $control_memory"
echo -e "${GREEN}IP Address:${NC} $control_ip"

echo
echo -e "${BLUE}Managed Nodes:${NC}"

# Get managed nodes information
while IFS= read -r line; do
    if [[ $line == *"ansible_user"* ]]; then
        node=$(echo $line | awk '{print $1}')
        details=$(get_node_details $node)

        echo -e "${BLUE}Node: $node${NC}\n----------------------------"
        echo -e "$details"
    fi
done < "$inventory_file"
