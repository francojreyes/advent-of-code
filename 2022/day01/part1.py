from sys import stdin

curr = 0
max = 0
for line in stdin:
    line = line.strip()
    if line == "":
        if curr > max:
            max = curr
        curr = 0
    else:
        curr += int(line)

print(max)
