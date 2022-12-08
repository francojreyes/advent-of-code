from sys import stdin


def read_trees():
    trees = []
    for line in stdin:
        trees.append([int(c) for c in line.strip()])
    return trees


def visible(trees, x, y):
    return all(trees[x][y] > trees[i][y] for i in range(x)) or \
           all(trees[x][y] > trees[i][y] for i in range(x + 1, len(trees))) or \
           all(trees[x][y] > trees[x][i] for i in range(y)) or \
           all(trees[x][y] > trees[x][i] for i in range(y + 1, len(trees[0])))


def scenic_score(trees, x, y):
    up = 0
    for i in reversed(range(x)):
        up += 1
        if trees[i][y] >= trees[x][y]:
            break

    left = 0
    for i in reversed(range(y)):
        left += 1
        if trees[x][i] >= trees[x][y]:
            break
    
    down = 0
    for i in range(x + 1, len(trees)):
        down += 1
        if trees[i][y] >= trees[x][y]:
            break
            
    right = 0
    for i in range(y + 1, len(trees[0])):
        right += 1
        if trees[x][i] >= trees[x][y]:
            break
    
    return up * down * left * right


if __name__ == '__main__':
    part1 = 0 # num visible from any side
    part2 = 0 # largest scenic score

    trees = read_trees()
    for i in range(len(trees)):
        for j in range(len(trees[0])):
            if visible(trees, i, j):
                part1 += 1

            score = scenic_score(trees, i, j)
            if score > part2:
                part2 = score

    print("Part 1:", part1)
    print("Part 2:", part2)
