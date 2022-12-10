#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TICKS 220
#define DELIM " \n"

int processTick(int tick, int X) {
    return tick <= MAX_TICKS && (tick - 20) % 40 == 0 ? tick * X : 0;
}

int main(void) {
    int X = 1;
    int tick = 0;

    int sum = 0;
    char line[BUFSIZ];
    while (tick < MAX_TICKS && fgets(line, BUFSIZ, stdin) != NULL) {
        // There is always at least 1 tick of do nothing
        sum += processTick(++tick, X);

        char *command = strtok(line, DELIM);
        if (strcmp(command, "addx") == 0) {
            // Process tick then increment X
            sum += processTick(++tick, X);
            X += atoi(strtok(NULL, DELIM));
        }
    }

    printf("%d\n", sum);
    return 0;
}
