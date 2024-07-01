# Ansible Status Tool

This tool displays information about the Ansible control machine and current managed nodes connected to it.

## Requirements

- Ansible installed on the control machine.
- A valid inventory file.

## Directory Structure
```
ansible-status-tool/
├── ansible_status.sh
├── Makefile
└── README.md

```

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/EzioDEVio/ansible-status-tool.git
   cd ansible-status-tool
   ```

2. Make the script executable:

   ```
   chmod +x ansible_status.sh
   ```

## Usage

Run the script with your inventory file as an argument:

```
./ansible_status.sh /path/to/your/inventory.ini
```

# Example Output
```
Control Machine:
Hostname: control-machine
IP Address: 192.168.1.1
OS: Ubuntu 20.04.1 LTS
Kernel: 5.4.0-54-generic

Managed Nodes:
Node: node1
IP Address: 192.168.1.2
Status: SUCCESS

Node: node2
IP Address: 192.168.1.3
Status: UNREACHABLE

```
# Contributing
Feel free to submit pull requests to improve this tool

# License
This project is licensed under the MIT License.
