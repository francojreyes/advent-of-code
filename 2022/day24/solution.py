from math import lcm
from collections import deque

class Valley():
    def __init__(self, rows, cols):
        self.rows = rows
        self.cols = cols

    def start_pos(self):
        return (0, 1)
    
    def end_pos(self):
        return (self.rows + 1, self.cols)

    def movable_positions(self, pos):
        return [adj for adj in [
            pos,
            (pos[0] - 1, pos[1]),
            (pos[0] + 1, pos[1]),
            (pos[0], pos[1] - 1),
            (pos[0], pos[1] + 1),
        ] if self.valid_pos(adj)]
    
    def valid_pos(self, pos):
        return pos == self.start_pos() or \
               pos == self.end_pos() or \
               (1 <= pos[0] <= self.rows and 1 <= pos[1] <= self.cols)
    
    def wrap_pos(self, pos, direction):
        match direction:
            case "^":
                return (self.rows, pos[1])
            case ">":
                return (pos[0], 1)
            case "v":
                return (1, pos[1])
            case "<":
                return (pos[0], self.cols)


class Blizzard():
    def __init__(self, pos, direction):
        self.pos = pos
        self.direction = direction

    def move(self, grid):
        match self.direction:
            case "^":
                next_pos = (self.pos[0] - 1, self.pos[1])
            case ">":
                next_pos = (self.pos[0], self.pos[1] + 1)
            case "v":
                next_pos = (self.pos[0] + 1, self.pos[1])
            case "<":
                next_pos = (self.pos[0], self.pos[1] - 1)
        
        if not grid.valid_pos(next_pos):
            next_pos = grid.wrap_pos(next_pos, self.direction)
        
        self.pos = next_pos


def read_input():
    '''
    Read input from stdin
    Return a Valley object to represent the bounds and
    a list of position sets that are the positions occupied by blizzards each cycle.

    Note:
    All horizontal blizzards repeat the same movement pattern after cols cycles
    Similarly, all vertical blizzards repeat the same movement pattern after rows cycles
    Thus, after lcm(cols, rows) cycles ALL blizzards repeat the same movement pattern
    '''
    inp = open(0).read()
    lines = inp.split("\n")
    valley = Valley(len(lines) - 2, len(lines[0]) - 2)

    # Initialise all blizzards
    blizzards: list[Blizzard] = []
    for i, line in enumerate(lines):
        for j, c in enumerate(line):
            if c not in "#.":
                blizzards.append(Blizzard((i, j), c))

    # Calculate positions for each cycle
    n = lcm(valley.rows, valley.cols)
    blizzard_positions = [set() for _ in range(n)]
    for i in range(n):
        # Add to positions for current cycle
        for blizzard in blizzards:
            blizzard_positions[i].add(blizzard.pos)
            
        # Move all blizzards
        for blizzard in blizzards:
            blizzard.move(valley)
    
    return valley, blizzard_positions


def bfs_shortest_path(valley, blizzard_positions, start, end, moves):
    '''
    BFS but visited is tracked by cycle and blizzard/OOB positions are invalid
    Also keep the queue for the current move and next move separate
    '''
    n = len(blizzard_positions)
    visited = [set() for _ in range(n)]
    curr_q = deque([start])
    while True:
        next_q = deque([])

        while len(curr_q) > 0:
            # if visited continue
            pos = curr_q.popleft()
            if pos in visited[moves % n]:
                continue
            visited[moves % n].add(pos)

            if pos in blizzard_positions[moves % n]:
                continue

            if pos == end:
                return moves

            next_q.extend(valley.movable_positions(pos))

        curr_q = next_q
        moves += 1


def part1(valley, blizzard_positions):
    return bfs_shortest_path(valley, blizzard_positions, valley.start_pos(), valley.end_pos(), 0)


def part2(valley, blizzard_positions):
    first_leg = bfs_shortest_path(valley, blizzard_positions, valley.start_pos(), valley.end_pos(), 0)
    second_leg = bfs_shortest_path(valley, blizzard_positions, valley.end_pos(), valley.start_pos(), first_leg)
    return bfs_shortest_path(valley, blizzard_positions, valley.start_pos(), valley.end_pos(), second_leg)


if __name__ == '__main__':
    valley, blizzard_positions = read_input()
    print("Part 1:", part1(valley, blizzard_positions))
    print("Part 2:", part2(valley, blizzard_positions))
