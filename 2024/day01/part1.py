l1, l2 = zip(*(map(int, line.split()) for line in open("input.txt", "r").readlines()))
print(sum(map(lambda x: abs(x[0] - x[1]), zip(sorted(l1), sorted(l2)))))
