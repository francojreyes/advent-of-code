from sys import stdin

def translate(position: tuple[int, int], direction: str):
    match direction:
        case "U":
            return (position[0] - 1, position[1])
        case "D":
            return (position[0] + 1, position[1])
        case "L":
            return (position[0], position[1] - 1)
        case "R":
            return (position[0], position[1] + 1)


def follow(tail: tuple[int, int], head: tuple[int, int]):
    diff = (head[0] - tail[0], head[1] - tail[1])
    if max(abs(diff[0]), abs(diff[1])) <= 1:
        return tail
    match diff:
        case (-2, 0):
            return translate(tail, "U")
        case (2, 0):
            return translate(tail, "D")
        case (0, -2):
            return translate(tail, "L")
        case (0, 2):
            return translate(tail, "R")
        case (1, 2):
            return translate(translate(tail, "D"), "R")
        case (-1, 2):
            return translate(translate(tail, "U"), "R")
        case (-2, -1):
            return translate(translate(tail, "U"), "L")
        case (-2, 1):
            return translate(translate(tail, "U"), "R")
        case (1, -2):
            return translate(translate(tail, "D"), "L")
        case (-1, -2):
            return translate(translate(tail, "U"), "L")
        case (2, -1):
            return translate(translate(tail, "D"), "L")
        case (2, 1):
            return translate(translate(tail, "D"), "R")
        case (-2, 2):
            return translate(translate(tail, "U"), "R")
        case (-2, -2):
            return translate(translate(tail, "U"), "L")
        case (2, -2):
            return translate(translate(tail, "D"), "L")
        case (2, 2):
            return translate(translate(tail, "D"), "R")
        case _:
            raise ValueError(f"Invalid diff of {diff}")


def print_board(head, tail):
    for i in range(-4, 1):
        for j in range(6):
            if head == (i, j):
                print("H", end="")
            elif tail == (i, j):
                print("T", end="")
            elif (i, j) == (0, 0):
                print("s", end="") 
            else:
                print(".", end="")
        print()
    print()



if __name__ == '__main__':
    rope = [(0, 0)] * 10
    visited = set()
    visited.add(rope[len(rope) - 1])
    for line in stdin:
        direction = line.split()[0]
        for _ in range(int(line.split()[1])):
            # print_board(head, tail)
            rope[0] = translate(rope[0], direction)
            for i in range(1, len(rope)):
                rope[i] = follow(rope[i], rope[i - 1]) 
            visited.add(rope[len(rope) - 1])
    print(len(visited))