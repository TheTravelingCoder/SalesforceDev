import glob
import os
import json

allFindings = {}

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
findings = open(latest_file)
print("JSON File downloaded: " + latest_file)
scanFindings = json.load(findings)
for severity, bugsFound in scanFindings['scanSummary'].items():
    if severity == "Critical":
        #Change below to change amount of Critical bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            allFindings.update({severity: bugsFound})
    if severity == "High":
        #Change below to change amount of High bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            allFindings.update({severity: bugsFound})
    if severity == "Medium":
        #Change below to change amount of Medium bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            allFindings.update({severity: bugsFound})
    if severity == "Low":
        #Change below to change amount of Low bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            allFindings.update({severity: bugsFound})
if len(allFindings) > 0:
    for severity, bugsFound in allFindings.items():
        print(severity, bugsFound)

    exit("S4 Found Too Many Bugs, Exiting Build")
