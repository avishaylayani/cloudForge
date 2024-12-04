import json
master_ip=None
try:
    with open('terraform/inventory.json') as file:
        inventory_json = json.load(file)
    inventory_ini="[all]\n"
    for i in inventory_json:
        inventory_ini+=i['name']+" ansible_host="+i['ip']+"\n"

    inventory_ini+="\n[k8s_master]\n"

    inventory_ini+="\n[k8s_nodes]\n"

    for i in inventory_json:
        if "node" in i['name']:
            inventory_ini+=i['name']+"\n"
    for i in inventory_json:
        if "master" in i['name']:
            inventory_ini+=i['name']+"\n"
            master_ip=i['ip']

    inventory_ini+="\n[all:vars]\nmaster="+master_ip

    with open('ansible/inventory.ini', "w") as file:
        file.write(inventory_ini)

except FileNotFoundError:
    print("Error: The file 'terraform/inventory.json' was not found. Please ensure the file exists and the path is correct.")

except json.JSONDecodeError:
    print("Error: The file 'terraform/inventory.json' is not a valid JSON file. Please check its contents for proper JSON formatting.")

except ValueError as e:
    print(f"Error: {e}")

except Exception as e:
    print(f"An unexpected error occurred: {e}")