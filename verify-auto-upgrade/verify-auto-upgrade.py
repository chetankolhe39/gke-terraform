import json
import sys

with open("info.json", "r") as read_file:
    data = json.load(read_file)['resources']

for resource in data:
    if ("management" in resource and "name" in resource) and bool(resource["management"]):
        print("Auto upgrade is enabled on node pool")
    else:
        print("Auto upgrade is disabled on node pool")
