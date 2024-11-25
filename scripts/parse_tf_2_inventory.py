"""
This script generates an Ansible inventory in INI format from a JSON file produced by Terraform.

Input:
- JSON file located at 'terraform/inventory.json' which contains details about instances.
  The JSON is expected to be an array of objects, each containing:
  - "ip": The public IP address of the instance.
  - "name": The instance's name, which is used to group the instances into inventory groups.

Output:
- INI file located at 'ansible/inventory.ini' which contains named hosts and group definitions
  that can be used directly by Ansible.

Groups created:
1. `[all]`: Contains all hosts listed in the JSON file.
2. `[k8s_nodes]`: Contains all Kubernetes nodes (`k8s_nodeX`).
3. Specific groups for `cicd`, `k8s_master`.

Usage:
- The script reads from 'terraform/inventory.json', processes the data, and writes an inventory 
  file to 'ansible/inventory.ini'.
- If any errors occur during the process, the script handles them and provides a descriptive message.
"""

import json
from collections import defaultdict

try:
    # Load the JSON inventory
    with open('terraform/inventory.json') as file:
        inventory_json = json.load(file)

    # Initialize a dictionary to hold groups and names
    groups = defaultdict(list)
    host_entries = []

    # Loop through the JSON to build the inventory structure
    for instance in inventory_json:
        name = instance.get('name')
        ip = instance.get('ip')

        if not name or not ip:
            raise ValueError(f"Instance data is missing 'name' or 'ip'. Instance: {instance}")

        # Add the host entry with ansible_host variable
        host_entries.append(f"{name} ansible_host={ip}")

        # Add to the relevant group
        groups['all'].append(name)

        if name == "cicd":
            groups['cicd'].append(name)
        elif name == "k8s_master":
            groups['k8s_master'].append(name)
        elif "k8s_node" in name:
            groups['k8s_nodes'].append(name)  # Add to k8s_nodes group

    # Create the inventory string
    inventory_lines = []

    # Add host entries to inventory
    inventory_lines.append("[all]")
    inventory_lines.extend(host_entries)

    # Add groups dynamically
    for group, hosts in groups.items():
        if group != "all":  # Skip 'all' since it's already added
            inventory_lines.append(f"\n[{group}]")
            inventory_lines.extend(hosts)

    # Write the inventory to the file
    inventory_ini = "\n".join(inventory_lines)
    with open('ansible/inventory.ini', "w") as file:
        file.write(inventory_ini)

    print("Ansible inventory file 'ansible/inventory.ini' has been successfully created.")

except FileNotFoundError:
    print("Error: The file 'terraform/inventory.json' was not found. Please ensure the file exists and the path is correct.")

except json.JSONDecodeError:
    print("Error: The file 'terraform/inventory.json' is not a valid JSON file. Please check its contents for proper JSON formatting.")

except ValueError as e:
    print(f"Error: {e}")

except Exception as e:
    print(f"An unexpected error occurred: {e}")
