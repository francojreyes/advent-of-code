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
    new_tail = tail
    diff = (head[0] - tail[0], head[1] - tail[1])

    if max(abs(diff[0]), abs(diff[1])) <= 1:
        return tail

    if diff[0] > 0:
        new_tail = translate(new_tail, "D")
    elif diff[0] < 0:
        new_tail = translate(new_tail, "U")
    
    if diff[1] > 0:
        new_tail = translate(new_tail, "R")
    elif diff[1] < 0:
        new_tail = translate(new_tail, "L")

    return new_tail


if __name__ == '__main__':
    rope = [(0, 0)] * 10
    visited = set()
    visited.add(rope[len(rope) - 1])
    for line in stdin:
        direction = line.split()[0]
        for _ in range(int(line.split()[1])):
            rope[0] = translate(rope[0], direction)
            for i in range(1, len(rope)):
                rope[i] = follow(rope[i], rope[i - 1]) 
            visited.add(rope[len(rope) - 1])
    print(len(visited))