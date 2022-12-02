import bisect
from sys import stdin

N = 3

largest = [0] * N
curr = 0
for line in stdin:
    line = line.strip()
    if line == "":
        if curr > largest[0]:
            bisect.insort(largest, curr)
            largest = largest[1:]
        curr = 0
    else:
        curr += int(line)

print(sum(largest))
