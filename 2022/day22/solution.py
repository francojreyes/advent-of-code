import re

SPACE = "."
WALL = "#"

RIGHT = 0
DOWN = 1
LEFT = 2
UP = 3

def read_map():
    grid = {}

    i = 1
    line = input()
    while line:
        for j, c in enumerate(line):
            coord = (i, j + 1)
            if c != " ":
                grid[coord] = c
        i += 1
        line = input()

    return grid


def plane_wrap(grid, pos, facing):
    if facing == RIGHT:
        return min((x for x in grid if x[0] == pos[0]), key=lambda x: x[1])
    elif facing == DOWN:
        return min((x for x in grid if x[1] == pos[1]), key=lambda x: x[0])
    elif facing == LEFT:
        return max((x for x in grid if x[0] == pos[0]), key=lambda x: x[1])
    elif facing == UP:
        return max((x for x in grid if x[1] == pos[1]), key=lambda x: x[0])


def cube_wrap(grid, pos, facing):
    '''
    Hardcoded for the input lol
    '''
    row, col = pos
    # Top of A -> Left of F (1, 51 -> 151, 1)
    if row == 1 and 50 < col <= 100:
        return (150 + (col - 50), 1)
    # Left of A -> Left of D (inverted) (1, 51 -> 150, 1)
    elif 0 < row <= 50 and col == 51:
        return (151 - row, 1)
    # Top of B -> Bottom of F (1, 101 -> 200, 1)
    elif row == 1 and 100 < col <= 150:
        return (200, col - 100)
    # Right of B -> Right of E (inverted) (1, 150 -> 150, 100)
    elif 0 < row <= 50 and col == 150:
        return (151 - row, 100)
    # Bottom of B -> Right of C (50, 101 -> 51, 100)
    elif row == 50 and 100 < col <= 150:
        return (50 + (col - 100), 100)
    # Left of C -> Top of D (51, 51 -> 101, 1)
    elif 50 < row <= 100 and col == 51:
        return (101, row - 50)
    # Right of C -> Bottom of B (51, 100 -> 50, 101)
    elif 50 < row <= 100 and col == 100:
        return (50, 100 + (row - 50))
    # Top of D -> Left of C (101, 1 -> 51, 51)
    elif row == 101 and 0 < col <= 50:
        return (50 + col, 51)
    # Left of D -> Left of A (inverted)
    elif 100 < row <= 150 and col == 1:
        return (51 - (row - 100), 51)
    # Right of E -> Right of B (inverted)
    elif 100 < row <= 150 and col == 100:
        return (51 - (row - 100), 150)
    # Bottom of E -> Right of F
    elif row == 150 and 50 < col <= 100:
        return (150 + (col - 50), 50)
    # Right of F -> Bottom of E
    elif 150 < row <= 200 and col == 50:
        return (150, 50 + (row - 150))
    # Bottom of F -> Top of B
    elif row == 200 and 0 < col <= 50:
        return (1, 100 + col)
    # Left of F -> Top of A
    elif 150 < row <= 200 and col == 1:
        return (1, 50 + (row - 150))
    

def move(grid, pos, facing, wrap_function):
    if facing == RIGHT:
        next_pos = (pos[0], pos[1] + 1)
    elif facing == DOWN:
        next_pos = (pos[0] + 1, pos[1])
    elif facing == LEFT:
        next_pos = (pos[0], pos[1] - 1)
    elif facing == UP:
        next_pos = (pos[0] - 1, pos[1])
    
    if next_pos not in grid:
        next_pos = wrap_function(grid, pos, facing)
    
    return next_pos if grid[next_pos] != WALL else pos


def turn(facing, direction):
    directions = [RIGHT, DOWN, LEFT, UP]
    idx = directions.index(facing)
    return directions[(idx + 1) % 4] if direction == "R" else directions[idx - 1]


if __name__ == '__main__':
    grid = read_map()    
    directions = re.findall(r"[0-9]+|L|R", input())

    pos = plane_wrap(grid, (1, 1), RIGHT)
    print(pos)
    facing = RIGHT
    for direction in directions:
        if direction.isnumeric():
            for _ in range(int(direction)):
                # Use plane_wrap for part1, cube_wrap for part2
                pos = move(grid, pos, facing, cube_wrap)
                print(pos)
        else:
            facing = turn(facing, direction)
    
    print(*pos, facing)
    print(1000 * pos[0] + 4 * pos[1] + facing)
