import glob
import os
import json

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
findings = open(latest_file)

scanFindings = json.load(findings)
for i, x in scanFindings['scanSummary'].items():
    if i == "Critical":
        print(i)
        print(x)
    if i == "High":
        print(i)
        print(x)
    if i == "Medium":
        print(i)
        print(x)
    if i == "Low":
        print(i)
        print(x)

print(latest_file)