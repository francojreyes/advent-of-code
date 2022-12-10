#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TICKS 240
#define DELIM " \n"

void processTick(int tick, int X) {
    putchar(abs(tick % 40 - X) <= 1 ? '#' : '.');
    if (tick % 40 == 39) putchar('\n');
}

int main(void) {
    int X = 1;
    int tick = 0;

    char line[BUFSIZ];
    while (tick < MAX_TICKS && fgets(line, BUFSIZ, stdin) != NULL) {
        // There is always at least 1 tick of do nothing
        processTick(tick++, X);

        char *command = strtok(line, DELIM);
        if (strcmp(command, "addx") == 0) {
            // Process tick then increment X
            processTick(tick++, X);
            X += atoi(strtok(NULL, DELIM));
        }
    }

    return 0;
}
