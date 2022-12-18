from itertools import chain

WIDTH = 7
N = 100000

PATTERNS = [
    [(0, 0), (0, 1), (0, 2), (0, 3)], # -
    [(1, 0), (0, 1), (1, 1), (2, 1), (1, 2)], # +
    [(0, 0), (0, 1), (0, 2), (1, 2), (2, 2)], # backwards L
    [(0, 0), (1, 0), (2, 0), (3, 0)], # |
    [(0, 0), (0, 1), (1, 0), (1, 1)], # square
]

LEFT = (0, -1)
RIGHT = (0, 1)
DOWN = (-1, 0)


def valid_position(pos):
    return pos[0] > 0 and 0 <= pos[1] < WIDTH


def move(stopped_rocks, rock, direction):
    '''
    Stopped rocks is set of positions with rocks
    Rock is a list of positions of the current rock
    Direction is a tuple with the direction to move in
    '''
    moved = [(pos[0] + direction[0], pos[1] + direction[1]) for pos in rock]
    if all(valid_position(pos) and pos not in stopped_rocks for pos in moved):
        return moved
    else:
        return rock


def visualise(stopped_rocks, rock):
    height = max(chain(stopped_rocks, rock), key=lambda x: x[0])[0]
    for i in reversed(range(1, height + 1)):
        print("|", end="")
        for j in range(WIDTH):
            if (i, j) in rock:
                print("@", end="")
            elif (i, j) in stopped_rocks:
                print("#", end="")
            else:
                print(".", end="")
        print("|")
    print("+" + "-" * WIDTH + "+")
    print()


if __name__ == '__main__':
    jet_pattern = input()

    rocks = 0
    jets = 0
    stopped_rocks = set()
    height = 0
    iterations = []
    while rocks < N:
        # Calculate the positions of the rock
        start_pos = (height + 4, 2)
        curr_pattern = PATTERNS[rocks % len(PATTERNS)]
        rock = [(start_pos[0] + pos[0], start_pos[1] + pos[1]) for pos in curr_pattern]

        # Calculate where the rock falls to
        i = 0
        while True:
            # Simulate rock falling
            if i % 2 == 0:
                # On even ticks, jets move the rock left/right
                direction = jet_pattern[jets % len(jet_pattern)]
                jets += 1
                match direction:
                    case "<":
                        rock = move(stopped_rocks, rock, LEFT)
                    case ">":
                        rock = move(stopped_rocks, rock, RIGHT)
            else:
                # On odd ticks, rock falls
                moved_rock = move(stopped_rocks, rock, DOWN)
                if moved_rock == rock:
                    # If rock did not move, it came to rest
                    iterations.append(i)
                    break
                else:
                    rock = moved_rock
            i += 1

        # Add it to stopped rocks and also check heights
        stopped_rocks.update(rock)
        rock_height = max(rock, key=lambda pos: pos[0])[0]
        if rock_height > height:
            height = rock_height
        rocks += 1

    print(height)
    iterations.sort()
    print(f"Min: {iterations[0]}\tMax: {iterations[-1]}\tAvg: {sum(iterations) // len(iterations)}\tMed: {iterations[len(iterations) // 2]}")
        
