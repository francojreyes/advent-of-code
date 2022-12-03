#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ALPHABET_SIZE 26

int alphabetToIdx(char c);

int main(void) {

    int sum = 0;
    char line[BUFSIZ];
    while (fgets(line, BUFSIZ, stdin) != NULL) {
        bool seen[ALPHABET_SIZE * 2] = {};
        int len = strlen(line) - 1;
        int mid = len / 2;
        
        // Read first half and mark as seen
        for (int i = 0; i < mid; i++) {
            seen[alphabetToIdx(line[i])] = true;
        }

        // Read second half for something that has been seen
        for (int i = mid; i < len; i++) {
            if (seen[alphabetToIdx(line[i])]) {
                sum += alphabetToIdx(line[i]) + 1;
                break;
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