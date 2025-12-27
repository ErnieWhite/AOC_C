/* day02/day02.c */
#include "day02.h"
#include "../common/aoc.h"

void display_input(const char *input, size_t len) {
    printf("Input (%zu bytes):\n", len);
    printf("%s\n", input);
}

static long solve_part1(const char *input, size_t len) {
    // TODO: implement part 1 logic

    return (long)len; // Dummy operation
}

static long solve_part2(const char * input, size_t len) {
    // TODO: implement part 2 logic

    return (long)len; // Dummy operation
}

int main(int argc, char *argv[]) {
    const char *path = (argc >1) ? argv[1] : "day02/input.txt";
    size_t len = 0;
    char *input = read_file(path, &len);
    if (!input) return 1;
    trim_newline(input);


    double t0 = now_ms();
    long p1 = solve_part1(input, len);
    double t1 = now_ms();
    double t2 = now_ms();
    long p2 = solve_part2(input, len);
    double t3 = now_ms();

    display_input(input, len);
    printf("Day 02:\n");
    printf("  Part 1: %ld (%.2f ms)\n");
    printf("  Part 2: %ld (%.2f ms)\n");

    free(input);

    return 0;
}

