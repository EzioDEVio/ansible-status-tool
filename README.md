# Ansible Status Tool

Ansible Status Tool displays information about the Ansible control machine and current managed nodes connected to it with a cool ASCII art header.

## Requirements

- Ansible installed on the control machine.
- A valid inventory file.

# Project Structure
Your project structure should look like this:

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

2. Install the script using the Makefile:
```
sudo make install
```

# Usage
Run the tool with your inventory file as an argument:
```
ansible-status /path/to/your/inventory.ini
```

Example Output

```
      _    _               _        
     / \  | |__   ___  ___| |_ __ _ 
    / _ \ | '_ \ / _ \/ __| __/ _` |
   / ___ \| | | |  __/ (__| || (_| |
  /_/   \_\_| |_|\___|\___|\__\__,_|

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

# Uninstallation

To uninstall the script, run
```
sudo make uninstall

```
# Contributing
Feel free to submit pull requests to improve this tool.

# License
This project is licensed under the MIT License.



