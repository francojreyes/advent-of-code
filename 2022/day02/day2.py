from sys import stdin

ROCK = 1
PAPER = 2
SCISSORS = 3

LOSS = 0
DRAW = 3
WIN = 6

PART_1 = {
    "A": {
        "X": ROCK + DRAW,
        "Y": PAPER + WIN,
        "Z": SCISSORS + LOSS
    },
    "B": {
        "X": ROCK + LOSS,
        "Y": PAPER + DRAW,
        "Z": SCISSORS + WIN
    },
    "C": {
        "X": ROCK + WIN,
        "Y": PAPER + LOSS,
        "Z": SCISSORS + DRAW
    }
}

PART_2 = {
    "A": {
        "X": SCISSORS + LOSS,
        "Y": ROCK + DRAW,
        "Z": PAPER + WIN
    },
    "B": {
        "X": ROCK + LOSS,
        "Y": PAPER + DRAW,
        "Z": SCISSORS + WIN
    },
    "C": {
        "X": PAPER + LOSS,
        "Y": SCISSORS + DRAW,
        "Z": ROCK + WIN
    }
}

score = 0
for line in stdin:
    opponent, mine = line.split()
    score += PART_2[opponent][mine]

print(score)
