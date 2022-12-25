#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

long snafuToNum(char *snafu);
int snafuDigitToNum(char snafu);
void numToSnafu(long value, char *buf);
char numToSnafuDigit(int value);
void sumSnafu(char *dest, char *a, char *b);

int main(void) {
    // char sum[BUFSIZ];
    // strcpy(sum, "0");
    // char value[BUFSIZ];
    // while (scanf("%s", value) == 1) {
    //     char tmpSum[BUFSIZ];
    //     sumSnafu(tmpSum, sum, value);
    //     strcpy(sum, tmpSum);
    // }

    // printf("%ld\n", snafuToNum(sum));
    // printf("%s\n", sum);

    long sum = 0;
    char buf[BUFSIZ];
    while (scanf("%s", buf) == 1) {
        sum += snafuToNum(buf);
    }

    printf("%ld\n", sum);
    numToSnafu(sum, buf);
    printf("%s\n", buf);

    return 0;
}

long snafuToNum(char *snafu) {
    int digits = strlen(snafu);
    long value = 0;
    long placeValue = 1;
    for (int i = digits - 1; i >= 0; i--) {
        value += placeValue * snafuDigitToNum(snafu[i]);
        placeValue *= 5;
    }
    return value;
}

int snafuDigitToNum(char snafu) {
    switch (snafu) {
        case '=': return -2;
        case '-': return -1;
        case '0': return 0;
        case '1': return 1;
        case '2': return 2;
        default:  return 0;
    }
}

void numToSnafu(long value, char *buf) {
    // Find how large it needs to be
    long placeValue = 1;
    long maxValue = 2;
    while (labs(value) > maxValue) {
        placeValue *= 5;
        maxValue += 2 * placeValue;
    }

    int i = 0;
    while (placeValue >= 1) {
        int digit = round(1.0 * value / placeValue);
        buf[i++] = numToSnafuDigit(digit);
        value -= digit * placeValue;
        placeValue /= 5;
    }
    buf[i] = '\0';
}

char numToSnafuDigit(int value) {
    switch (value) {
        case -2: return '=';
        case -1: return '-';
        case 0:  return '0';
        case 1:  return '1';
        case 2:  return '2';
        default: return '\0';
    }
}

void sumSnafu(char *dest, char *a, char *b) {
    int aLen = strlen(a);
    int bLen = strlen(b);
    int destLen = (aLen > bLen ? aLen : bLen) + 1;
    dest[destLen] = '\0';

    int carry = 0;
    for (int i = 0; i < destLen; i++) {
        int value = carry;
        if (i < aLen) value += snafuDigitToNum(a[aLen - 1 - i]);
        if (i < bLen) value += snafuDigitToNum(b[bLen - 1 - i]);

        char buf[BUFSIZ];
        numToSnafu(value, buf);
        if (strlen(buf) == 2) {
            carry = snafuDigitToNum(buf[0]);
            dest[destLen - 1 - i] = buf[1];
        } else {
            carry = 0;
            dest[destLen - 1 - i] = buf[0];
        }
    }

    if (dest[0] == '0') {
        for (int i = 0; i < destLen; i++) {
            dest[i] = dest[i + 1];
        }
    }
}
