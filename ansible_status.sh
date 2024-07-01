#!/bin/bash

# Function to fetch node details
get_node_details() {
    local node=$1
    local details=""
    
    logo=$(ansible -i $inventory_file -m shell -a 'neofetch --stdout' $node 2>/dev/null)
    os=$(echo "$logo" | grep 'OS:')
    host=$(echo "$logo" | grep 'Host:')
    kernel=$(echo "$logo" | grep 'Kernel:')
    uptime=$(echo "$logo" | grep 'Uptime:')
    packages=$(echo "$logo" | grep 'Packages:')
    shell=$(echo "$logo" | grep 'Shell:')
    term=$(echo "$logo" | grep 'Terminal:')
    cpu=$(echo "$logo" | grep 'CPU:')
    memory=$(echo "$logo" | grep 'Memory:')
    ip=$(ansible -i $inventory_file -m setup -a 'filter=ansible_default_ipv4.address' $node 2>/dev/null | grep ansible_default_ipv4.address)

    details+="${GREEN}OS:${NC} $(echo $os | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Host:${NC} $(echo $host | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Kernel:${NC} $(echo $kernel | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Uptime:${NC} $(echo $uptime | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Packages:${NC} $(echo $packages | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Shell:${NC} $(echo $shell | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Resolution:${NC} preferred\n"
    details+="${GREEN}Terminal:${NC} $(echo $term | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}CPU:${NC} $(echo $cpu | awk -F": " '{print $2}' | xargs)\n"
    details+="${GREEN}Memory:${NC} $(echo $memory | xargs)\n"
    details+="${GREEN}IP Address:${NC} $(echo $ip | awk -F": " '{print $2}' | xargs)\n"

    echo -e "$details"
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
control_terminal=$TERM
control_cpu=$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)
control_memory=$(free -m | awk 'NR==2{printf "%sMiB / %sMiB\n", $3,$2 }')
control_logo=$(neofetch --stdout | grep -v 'OS:' | grep -v 'Host:' | grep -v 'Kernel:' | grep -v 'Uptime:' | grep -v 'Packages:' | grep -v 'Shell:' | grep -v 'Resolution:' | grep -v 'Terminal:' | grep -v 'CPU:' | grep -v 'Memory:' | grep -v 'GPU:')

# Add color variables
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Display control machine information
cat << "EOF"
  _____       _         ____                _        
 | ____| ____(_)  ___  |  _ \   ___ __   __(_)  ___  
 |  _|  |_  /| | / _ \ | | | | / _ \ \ / /| | / _ \ 
 | |___  / / | || (_) || |_| ||  __/ \ V / | || (_) |
 |_____|/___||_| \___/ |____/  \___|  \_/  |_| \___/ 
EOF

echo -e "$control_logo"
echo -e "${GREEN}Control Node: $control_hostname.localdomain${NC}\n----------------------------"
echo -e "${GREEN}OS:${NC} $control_os"
echo -e "${GREEN}Host:${NC} $control_hostname"
echo -e "${GREEN}Kernel:${NC} $control_kernel"
echo -e "${GREEN}Uptime:${NC} $control_uptime"
echo -e "${GREEN}Packages:${NC} $control_packages"
echo -e "${GREEN}Shell:${NC} $control_shell"
echo -e "${GREEN}Terminal:${NC} $control_terminal"
echo -e "${GREEN}CPU:${NC} $control_cpu"
echo -e "${GREEN}Memory:${NC} $control_memory"
echo -e "${GREEN}IP Address:${NC} $control_ip"

echo
echo -e "${GREEN}Managed Nodes:${NC}"

# Get managed nodes information
while IFS= read -r line; do
    if [[ $line == *"ansible_user"* ]]; then
        node=$(echo $line | awk '{print $1}')
        details=$(get_node_details $node)

        echo -e "${GREEN}Node: $node${NC}\n----------------------------"
        echo -e "$details"
    fi
done < "$inventory_file"
