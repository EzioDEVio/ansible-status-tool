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

2. Use the Makefile to install the script:

   ```
   sudo make install

   ```

3. You may need to kake the script executable(optional):

   ```
   chmod +x ansible_status.sh
   ```

## Uninstallation
To uninstall the script, use:
```
sudo make uninstall

```

## Usage

Run the script with your inventory file as an argument:

```
./ansible_status.sh /path/to/your/inventory.ini
```

# Example Output
```
  _____       _         ____                _        
 | ____| ____(_)  ___  |  _ \   ___ __   __(_)  ___  
 |  _|  |_  /| | / _ \ | | | | / _ \ \ / /| | / _ \ 
 | |___  / / | || (_) || |_| ||  __/ \ V / | || (_) |
 |_____|/___||_| \___/ |____/  \___|  \_/  |_| \___/ 

Control Node: control-machine.localdomain
----------------------------
OS: Ubuntu 22.04.3 LTS
Host: control-machine
Kernel: 5.15.153.1-microsoft-standard-WSL2
Uptime: 4 hours, 35 mins
Packages: 1497
Shell: /bin/bash
Resolution: 1920x1080
Terminal: xterm-256color
CPU: 12th Gen Intel i5-12450H (4) @ 2.495GHz
Memory: 1172MiB / 2849MiB
IP Address: 192.168.122.1

Managed Nodes:
Node: 192.168.254.174
----------------------------
OS: CentOS Linux 7 (Core) x86_64
Host: oracle
Kernel: 3.10.0-1160.el7.x86_64
Uptime: 4 hours, 35 mins
Packages: 1497 (rpm)
Shell: /bin/bash
Resolution: preferred
Terminal: /dev/pts/0
CPU: Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz
Memory: 1172MiB / 2849MiB
IP Address: 192.168.254.174


```
# Contributing
Feel free to submit pull requests to improve this tool

# License
This project is licensed under the MIT License.
