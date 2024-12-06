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

# Define console colors for output
class ConsoleColor:
    GREEN = '\033[92m'  # Green
    RED = '\033[91m'    # Red
    RESET = '\033[0m'   # Reset to default color

# Define input and output file paths
source_Filename = 'terraform/inventory.json'
output_Filename = 'ansible/inventory.ini'

try:
    # Step 1: Load the JSON inventory file
    with open(source_Filename) as file:
        inventory_json = json.load(file)

    # Step 2: Initialize data structures for groups and hosts
    groups = defaultdict(list)  # Holds group-to-host mappings
    host_entries = []           # Holds host definitions for INI format
    host_username = 'ubuntu'    # Default SSH username
    host_privet_key = 'cloudforge.pem'  # Private key for SSH

    # Step 3: Process each instance in the JSON inventory
    for instance in inventory_json:
        name = instance.get('name')  # Get the instance's name
        ip = instance.get('ip')      # Get the instance's IP address

        # Validate that name and IP are present
        if not name or not ip:
            raise ValueError(f"Instance data is missing 'name' or 'ip'. Instance: {instance}")

        # Add the host entry to the inventory with ansible-specific variables
        host_entries.append(f"{name} ansible_host={ip}") 
                            #  ansible_user={host_username} ansible_ssh_private_key_file={host_privet_key}")

        # Add the host to the 'all' group
        groups['all'].append(name)

        # Dynamically group hosts based on their name
        if "master" in name:
            groups['k8s_master'].append(name)  # Add to Kubernetes master group
        elif "node" in name:
            groups['k8s_nodes'].append(name)  # Add to Kubernetes nodes group
        # Add additional groups as needed
        # elif "some_condition" in name:
        #     groups['some_group'].append(name)

    # Step 4: Build the INI-format inventory as a list of strings
    inventory_lines = []

    # Add all hosts under the 'all' group
    inventory_lines.append("[all]")
    inventory_lines.extend(host_entries)

    # Add other groups dynamically
    for group, hosts in groups.items():
        if group != "all":  # Skip 'all' since it's already added
            inventory_lines.append(f"\n[{group}]")
            inventory_lines.extend(hosts)

    # Step 5: Write the generated inventory to the output file
    inventory_ini = "\n".join(inventory_lines)  # Join the inventory lines into a single string
    with open(output_Filename, "w") as file:
        file.write(inventory_ini)  # Save the inventory to the file

    # Print success message
    print(f"{ConsoleColor.GREEN} [v] Ansible inventory file {output_Filename} has been successfully created.{ConsoleColor.RESET}\n")

# Step 6: Handle errors gracefully and provide meaningful output
except Exception as e:
    match e:
        case FileNotFoundError():
            print(f"{ConsoleColor.RED} [!] The file {source_Filename} was not found. Please ensure the file exists and the path is correct.{ConsoleColor.RESET}\n")
        case json.JSONDecodeError():
            print(f"{ConsoleColor.RED} [!] The file {source_Filename} is not a valid JSON file. Please check its contents for proper JSON formatting.{ConsoleColor.RESET}\n")
        case ValueError():
            print(f"{ConsoleColor.RED} [!] {e}{ConsoleColor.RESET}\n")
        case _:
            print(f"{ConsoleColor.RED} [!] An unexpected error occurred: {e}{ConsoleColor.RESET}\n")