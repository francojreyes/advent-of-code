from collections import Counter

l1, l2 = zip(*(map(int, line.split()) for line in open("input.txt", "r").readlines()))
counts = Counter(l2)
print(sum(x * counts[x] for x in l1 if x in counts))
