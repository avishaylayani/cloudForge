import json

with open('terraform/inventory.json') as file:
    inventory_json = json.load(file)
inventory_ini="[all]\n"
for i in inventory_json:
    inventory_ini+=i['ip']+"\n"

inventory_ini+="\n[cicd]\n"

for i in inventory_json:
    if i['name'] == "cicd":
        inventory_ini+=i['ip']+"\n"

inventory_ini+="\n[k8s_master]\n"

for i in inventory_json:
    if i['name'] == "k8s_master":
        inventory_ini+=i['ip']+"\n"

inventory_ini+="\n[k8s_node]\n"

for i in inventory_json:
    if "k8s_node" in i['name']:
        inventory_ini+=i['ip']+"\n"
with open('ansible/inventory.ini', "w") as file:
    file.write(inventory_ini)