#! /usr/bin/env python
import os
import sys
import json
#print os.listdir(".")
with open(sys.argv[1]) as data_file:
    data = json.load(data_file)
#print data
#print data[sys.argv[2]]
for stat in sys.argv[2].split(","):
    if isinstance(data[stat], bool):
        if data[stat]:
            print stat, 1
        elif data[stat] == False:
            print stat, 0        
    else:
         print stat, data[stat]
