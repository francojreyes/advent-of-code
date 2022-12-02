from sys import stdin

ROCK = 1
PAPER = 2
SCISSORS = 3

LOSS = 0
DRAW = 3
WIN = 6

SCORE = {
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

score = 0
for line in stdin:
    opponent, mine = line.split()
    score += SCORE[opponent][mine]

print(score)
