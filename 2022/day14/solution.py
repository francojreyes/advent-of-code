from sys import stdin


def read_input():
    rocks = []
    for line in stdin:
        endpoints = [tuple(map(int,coord.split(","))) for coord in line.strip().split(" -> ")]
        for i in range(len(endpoints) - 1):
            rocks.extend(positions_between(endpoints[i], endpoints[i + 1]))
        rocks.append(endpoints[-1])
    return rocks


def positions_between(start, end):
    if start[0] < end[0]:
        return [(x, start[1]) for x in range(start[0], end[0])]
    elif start[0] > end[0]:
        return [(x, start[1]) for x in range(start[0], end[0], -1)]
    elif start[1] < end[1]:
        return [(start[0], y) for y in range(start[1], end[1])]
    elif start[1] > end[1]:
        return [(start[0], y) for y in range(start[1], end[1], -1)]
    else:
        return start


def fall(entities, sand_pos):
    down = (sand_pos[0], sand_pos[1] + 1)
    if down not in entities:
        return down
    
    down_left = (sand_pos[0] - 1, sand_pos[1] + 1)
    if down_left not in entities:
        return down_left

    down_right = (sand_pos[0] + 1, sand_pos[1] + 1)
    if down_right not in entities:
        return down_right
    
    return sand_pos


def next_sand(entities, bottom):
    pos = (500, 0)
    while True:
        next_pos = fall(entities, pos)
        if pos == next_pos or next_pos[1] == bottom:
            return next_pos
        else:
            pos = next_pos


def part1(entities):
    lowest_rock = max(x[1] for x in entities)
    num_sand = 0
    while True:
        pos = next_sand(entities, lowest_rock)
        if pos[1] == lowest_rock:
            break
        else:
            print(pos)
            entities.append(pos)
            num_sand += 1
    print(num_sand)


def part2(entities):
    floor = max(x[1] for x in entities) + 2
    q = [(500, 0)]
    entities = set(entities) # for efficiency
    num_sand = 0
    while q: # kinda BFS?
        pos = q.pop()
        if pos in entities or pos[1] == floor:
            continue
        else:
            entities.add(pos)
            num_sand += 1
        
        q.append((pos[0], pos[1] + 1))
        q.append((pos[0] - 1, pos[1] + 1))
        q.append((pos[0] + 1, pos[1] + 1))
    print(num_sand)


if __name__ == '__main__':
    entities = read_input()
    part2(entities)  
