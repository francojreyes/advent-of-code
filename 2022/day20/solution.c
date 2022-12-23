#include <stdio.h>
#include <stdlib.h>

#include <assert.h>

#define DEFAULT_CAPACITY 16
#define MIXES 10 // 1 for part1, 10 for part2
#define KEY 811589153 // 1 for part1, 811589153 for part2

typedef struct node *Node;
struct node {
    long value;
    Node prev;
    Node next;
};

typedef struct list *List;
struct list {
    Node head;
    Node tail;
};

typedef struct {
    List list;
    Node *order;
    int n;
} Input;

static Input readInput();
static void shift(List l, Node n, int places);

static List ListNew();
static void ListFree(List l);
static void ListAppend(List l, Node n);
static void ListInsertBefore(List l, Node n, Node before);
static void ListInsertAfter(List l, Node n, Node after);
static void ListShiftLeft(List l, Node n);
static void ListShiftRight(List l, Node n);
static void ListRemove(List l, Node n);
static void ListShow(List l);

int main(void) {
    Input input = readInput();
    long n = input.n;
    List l = input.list;
    Node *order = input.order;

    for (int i = 0; i < MIXES; i++) {
        for (int j = 0; j < n; j++) {
            shift(l, order[j], order[j]->value % (n - 1));
        }
    }


    Node curr = l->head;
    while (curr->value != 0) {
        curr = curr->next;
    }

    long sum = 0;
    for (int i = 1; i <= 3000; i++) {
        curr = curr->next ? curr->next : l->head;
        if (i % 1000 == 0) {
            sum += curr->value;
        }
    }
    printf("%ld\n", sum);

    free(order);
    ListFree(l);
    return 0;
}

static void shift(List l, Node n, int places) {
    if (places > 0) {
        for (int i = 0; i < places; i++) {
            ListShiftRight(l, n);
        }
    } else if (places < 0) {
        for (int i = 0; i > places; i--) {
            ListShiftLeft(l, n);
        }
    }
}

static Input readInput() {
    int num = 0;
    int capacity = DEFAULT_CAPACITY;
    Node *order = malloc(capacity * sizeof(Node));
    List l = ListNew();

    long input;
    while (scanf("%ld", &input) == 1) {
        Node n = calloc(1, sizeof(struct node));
        n->value = input * KEY;
        ListAppend(l, n);

        if (num == capacity) {
            capacity *= 2;
            order = realloc(order, capacity * sizeof(Node));
        }
        order[num++] = n;
    }

    return (Input){ l, order, num };
}

static List ListNew() {
    List l = malloc(sizeof(struct list));
    l->head = NULL;
    l->tail = NULL;
    return l;
}

static void ListFree(List l) {
    Node curr = l->head;
    while (curr != NULL) {
        Node tmp = curr;
        curr = curr->next;
        free(tmp);
    }
    free(l);
}

static void ListAppend(List l, Node n) {
    if (l->tail) {
        l->tail->next = n;
        n->prev = l->tail;
        n->next = NULL;
        l->tail = n;
    } else {
        l->head = l->tail = n;
        n->prev = n->next = NULL;
    }
}

static void ListInsertBefore(List l, Node n, Node before) {
    before->next = n;
    before->prev = n->prev;

    if (n == l->head) {
        l->head = before;
    } else {
        n->prev->next = before;
    }

    n->prev = before;
}

static void ListInsertAfter(List l, Node n, Node after) {
    after->prev = n;
    after->next = n->next;

    if (n == l->tail) {
        l->tail = after;
    } else {
        n->next->prev = after;
    }

    n->next = after;
}

static void ListShiftLeft(List l, Node n) {
    Node prev = n->prev;
    ListRemove(l, n);
    if (prev == NULL) {
        ListInsertAfter(l, l->tail->prev, n);
    } else if (prev->prev == NULL) {
        ListInsertAfter(l, l->tail, n);
    } else {
        ListInsertAfter(l, prev->prev, n);
    }
}

static void ListShiftRight(List l, Node n) {
    Node next = n->next;
    ListRemove(l, n);
    if (next == NULL) {
        ListInsertBefore(l, l->head->next, n);
    } else if (next->next == NULL) {
        ListInsertBefore(l, l->head, n);
    } else {
        ListInsertBefore(l, next->next, n);
    }
}

static void ListRemove(List l, Node n) {
    if (n == l->head)
        l->head = n->next;
    if (n == l->tail)
        l->tail = n->prev;
    if (n->next)
        n->next->prev = n->prev;
    if (n->prev)
        n->prev->next = n->next;
}

static void ListShow(List l) {
    for (Node curr = l->head; curr; curr = curr->next) {
        printf("%ld ", curr->value);
    }
    printf("\n");
}
