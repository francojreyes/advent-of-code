
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "Queue.h"

#define SEQ_LEN 14 // 4 for part1, 14 for part2
#define ALPHABET_LEN 26

int main(void) {
    // Track the total number of characters processed
    int total = 0;

    // A queue of items in the current sequence
    Queue q = QueueNew();

    // Track the number of each character seen in the current sequence
    int num[ALPHABET_LEN] = {};

    // Track how many duplicates have been seen in the current sequence
    int dupes = 0;

    int c;
    while ((c = getchar()) != EOF) {
        if (total++ >= SEQ_LEN) {
            // First item in queue is no longer in current sequence
            int remove = QueueDequeue(q);
            num[remove % 'a']--;

            // If decremented to 1, a dupe was removed
            if (num[remove % 'a'] == 1) {
                dupes--;
            }
        }

        // Increment next char, if incremented to 2 a dupe was added
        num[c % 'a']++;
        if (num[c % 'a'] == 2) {
            dupes++;
        }
        QueueEnqueue(q, c);

        // Check if we've found a no dupe sequence
        if (total >= SEQ_LEN && dupes == 0) {
            printf("%d\n", total);
            break;
        }
    }
}
