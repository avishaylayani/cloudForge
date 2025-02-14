<img src="assets/README.png" alt="README" style="width: 100%; height: 200px; object-fit: fit;">

| **[INSTALLATION](INSTALLATION.md)** | **[CONTRIBUTORS](CONTRIBUTORS.md)** | **[MENU GUIDE](menu/MENU.md)** |

# CloudForge Project

CloudForge is an infrastructure automation project designed to simplify cloud provisioning, configuration management, and Kubernetes cluster management. The project leverages tools like **Terraform**, **Ansible**, and **K3S** for infrastructure-as-code and deployment automation.

# CloudForge Project Diagram

```plaintext
                +------------------+
                |      GIT         |
                +------------------+
                        v
                        v
                +------------------+
                |   Terraform      |
                |  (S3 Bucket)     |
                +------------------+
                        v
                        v
                +------------------+
                |  Terraform State |
                | (Infrastructure) |
                +------------------+
                        v
                        v
            +<<<<<<<<<<<+>>>>>>>>>>>+
            v                       v
            v                       v
    +------------------+    +------------------+
    |     Ansible      |    |     CI/CD Tool   |
    |  Install K3S     |    |  (Deployments)   |>>>>>>>>>>>>>>>>>>>>>>+
    +------------------+    +------------------+                      v
            v                       v                                 v
            v                       v                                 v
            +>>>>>>>>>>>+<<<<<<<<<<<+                                 v      
                        v                                             v
                        v                                             v
    +------------------------------------------+                      v
    |               AWS EC2 Nodes              |                      v
    |            (3 Instances Total)           |                      v
    +------------------------------------------+                      v
                        v                                             v
                        v                                             v
    +------------------------------------------+                      v
    |             K3S Master Node              | <<<<<<<<<<<<<<<<<<<<<+              
    |                                          |        
    |             Manages Cluster              | <<<<<<<<<<<<<<<<<<<<<+             
    +------------------------------------------+                      v   
                        v                                             v 
                        v                             +----------------------------------+
            +<<<<<<<<<<<+>>>>>>>>>>>+                 |  www.prod-cloudforge.duckdns.org |    
            v                       v                 |  www.dev-cloudforge.duckdns.org  |        
            v                       v                 +----------------------------------+        
    +------------------+    +------------------+               
    |   K3S Worker     |    |   K3S Worker     |    
    |   Node (Dev)     |    |   Node (Prod)    |    
    |------------------|    |------------------|    
    |  - PSQL (Dev)    |    |  - PSQL (Prod)   |    
    |  - Dev Apps      |    |  - Prod Apps     |    
    +------------------+    +------------------+    
            v                       v            
            v                       v            
    +------------------+    +------------------+       
    |  Dev PostgreSQL  |    |  Prod PostgreSQL |       
    |   (on Dev Node)  |    |   (on Prod Node) |       
    +------------------+    +------------------+       
```

## Features

- Automated provisioning of AWS infrastructure using Terraform.
- Deployment and configuration management using Ansible.
- Kubernetes cluster management with K3S, including rollout and rollback operations.
- Modular menu-driven CLI for simplified user interactions.

---

## Dependencies

The following dependencies are required to run this project:

- **Bash** (Version 4.0+)
- **Terraform**
- **Ansible**
- **AWS CLI**
- **Python3**
- **jq** (For JSON parsing in shell scripts)

### Platform-Specific Tools:
- **Linux**: `xdg-open` for opening URLs.
- **macOS**: `open` command for opening URLs.
- **Windows**: WSL or native compatibility for running Bash scripts.

---

## Project Structure

```plaintext
CloudForge/
├── menu/                   # Menu scripts for modular operations
│   ├── banner.sh           # Displays project banner
│   ├── colorize.sh         # Adds colorized output for menus
│   ├── dependencies.sh     # Checks and installs required dependencies
│   ├── terraform.sh        # Terraform operations (init, apply, destroy)
│   ├── ansible.sh          # Ansible operations (provisioning and configuration)
│   ├── k3s.sh              # K3S operations (rollout and rollback)
│   ├── menu.md             # Guide for menu navigation and usage
│   └── step_by_step.sh     # Guided step-by-step operations
├── terraform/              # Main Terraform configurations
│   ├── main.tf             # Core infrastructure setup
│   ├── variables.tf        # Input variables
│   └── outputs.tf          # Outputs for dependencies like S3 bucket
├── terraform_bucket/       # Separate module for S3 backend bucket
├── ansible/                # Ansible playbooks and configuration files
│   ├── master_ip           # File to store the K3S master IP
│   └── main.yml            # Ansible playbook for configuration
├── scripts/                # Supporting Python scripts
│   └── parsh_inventory.py  # Script to parse inventory files for Ansible
├── main_menu.sh            # Main entry point script for the project
├── README.md               # Project overview and documentation
└── installation.md         # Detailed installation instructions
```