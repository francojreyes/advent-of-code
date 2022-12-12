from sys import stdin
from collections import deque


def read_input():
    heightmap = []
    for line in stdin:
        heightmap.append([c for c in line.strip()])
    return heightmap


def height(heightmap, pos):
    char = heightmap[pos[0]][pos[1]]
    if char == 'S':
        char = 'a'
    elif char == 'E':
        char = 'z'
    
    return ord(char) % ord('a')


def can_step(heightmap, from_pos, to_pos):
    return height(heightmap, to_pos) - height(heightmap, from_pos) <= 1


def valid(heightmap, pos):
    return pos[0] >= 0 and pos[1] >= 0 and pos[0] < len(heightmap) and pos[1] < len(heightmap[0])


def adjacent_positions(heightmap, is_adjacent, pos):
    adj = [
        (pos[0] - 1, pos[1]),
        (pos[0] + 1, pos[1]),
        (pos[0], pos[1] - 1),
        (pos[0], pos[1] + 1)
    ]
    return [x for x in adj if valid(heightmap, x) and is_adjacent(pos, x)]
    

def get_start_end(heightmap):
    for i in range(len(heightmap)):
        for j in range(len(heightmap[0])):
            if heightmap[i][j] == 'S':
                start = (i, j)
            elif heightmap[i][j] == 'E':
                end = (i, j)
    return start, end


def bfs_num_steps(heightmap, is_adjacent, start, end_condition):
    pred = [[None] * len(heightmap[0]) for _ in range(len(heightmap))]
    pred[start[0]][start[1]] = start

    q = deque([start])
    while len(q) > 0:
        n = q.popleft()
        if end_condition(n):
            break

        for adj in adjacent_positions(heightmap, is_adjacent, n):
            if pred[adj[0]][adj[1]] is None:
                pred[adj[0]][adj[1]] = n
                q.append(adj)

    steps = 0
    while n != pred[n[0]][n[1]]:
        steps += 1
        n = pred[n[0]][n[1]]
    
    return steps


if __name__ == '__main__':
    heightmap = read_input()
    start, end = get_start_end(heightmap)

    print("Part 1:", bfs_num_steps(
        heightmap,
        lambda x, y: can_step(heightmap, x, y),
        start,
        lambda x: heightmap[x[0]][x[1]] == 'E'
    ))

    print("Part 2:", bfs_num_steps(
        heightmap,
        lambda x, y: can_step(heightmap, y, x),
        end,
        lambda x: heightmap[x[0]][x[1]] in ['a', 'S']
    ))
