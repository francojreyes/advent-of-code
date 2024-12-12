s = "00992111777.44.333....5555.6666.....8888.."
print(sum(i * int(c) for i, c in enumerate(s) if c != '.'))
