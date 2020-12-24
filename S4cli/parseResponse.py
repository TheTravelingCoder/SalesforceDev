import glob
import os
import json

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
findings = open(latest_file)

scanFindings = json.load(findings)
for severity, bugsFound in scanFindings['scanSummary'].items():
    if severity == "Critical":
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("Too Many Critical Bugs")
    if severity == "High":
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("Too Many High Bugs")
    if severity == "Medium":
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("Too Many Medium Bugs")
    if severity == "Low":
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("Too Many Low Bugs")
print(latest_file)