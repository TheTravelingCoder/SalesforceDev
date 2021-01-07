import glob
import os
import json

list_of_files = glob.glob('./*.json') # * means all if need specific format then *.csv
latest_file = max(list_of_files, key=os.path.getctime)
findings = open(latest_file)

scanFindings = json.load(findings)
for severity, bugsFound in scanFindings['scanSummary'].items():
    if severity == "Critical":
        #Change below to change amount of Critical bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("S4 Found Too Many Critical Bugs, Exiting Build")
    if severity == "High":
        #Change below to change amount of High bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("S4 Found Too Many High Bugs, Exiting Build")
    if severity == "Medium":
        #Change below to change amount of Medium bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("S4 Found Too Many Medium Bugs, Exiting Build")
    if severity == "Low":
        #Change below to change amount of Low bugs you are OK with
        if bugsFound == 0:
            print(severity)
            print(bugsFound)
        else:
            exit("S4 Found Too Many Low Bugs, Exiting Build")
print(latest_file)
