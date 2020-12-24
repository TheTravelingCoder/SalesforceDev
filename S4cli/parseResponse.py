import glob
import os
import json

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
findings = open(latest_file)

scanFindings = json.load(findings)
for i, x in scanFindings['scanSummary'].items():
    if i == "Critical":
        if x == 0:
            print(i)
            print(x)
        else:
            exit("Too Many Critical Bugs")
    if i == "High":
        if x == 0:
            print(i)
            print(x)
        else:
            exit("Too Many High Bugs")
    if i == "Medium":
        if x == 0:
            print(i)
            print(x)
        else:
            exit("Too Many Medium Bugs")
    if i == "Low":
        if x == 0:
            print(i)
            print(x)
        else:
            exit("Too Many Low Bugs")
print(latest_file)