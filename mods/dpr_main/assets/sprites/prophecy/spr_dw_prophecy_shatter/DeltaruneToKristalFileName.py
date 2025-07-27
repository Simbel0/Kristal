import os
import re

oldname = input("Give the string to match: ")

pattern = re.compile(re.escape(oldname) + r'(\d+)(\.png)$')

count = 0
regexlist = []
for filename in os.listdir("."):
    match = pattern.match(filename)
    if match:
        number, ext = match.groups()
        regexlist.append((oldname, number, ext))
        count = count + 1

print(f"{count} matches found.")
if count == 0:
    exit()
newprefix = input("Give the new prefix: ")

regexlist.sort(key=lambda t: int(t[1]))

for nameparts in regexlist:
    currname = nameparts[0] + nameparts[1] + nameparts[2]
    number = int(nameparts[1]) + 1
    newname = newprefix + str(number).zfill(len(nameparts[1])) + nameparts[2]
    print(f"Renaming {currname} to {newname}")
    os.rename(currname, newname)