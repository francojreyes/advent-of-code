#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ALPHABET_SIZE 26
#define GROUP_SIZE 3

int alphabetToIdx(char c);

int main(void) {
    int sum = 0;
    char line[BUFSIZ];
    while (fgets(line, BUFSIZ, stdin) != NULL) {
        int tally[ALPHABET_SIZE * 2] = {};

        for (int i = 0; i < GROUP_SIZE; i++) {
            if (i != 0) {
                fgets(line, BUFSIZ, stdin);
            }

            bool seen[ALPHABET_SIZE * 2] = {};
            for (int i = 0; i < strlen(line) - 1; i++) {
                int idx = alphabetToIdx(line[i]);
                if (!seen[idx]) {
                    tally[idx]++;
                    seen[idx] = true;
                }
                if (tally[idx] == GROUP_SIZE) {
                    sum += idx + 1;
                    break;
                }
            }
        }
    }

    printf("%d\n", sum);
    return 0;
}

int alphabetToIdx(char c) {
    if ('a' <= c && c <= 'z') {
        return c % 'a';
    } else if ('A' <= c && c <= 'Z') {
        return ALPHABET_SIZE + c % 'A';
    }

    return -1;
}
