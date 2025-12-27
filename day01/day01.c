/* day01/day01.c */
#include "day01.h"
#include "../common/aoc.h"

void display_input(const char *input, size_t len) {
    printf("Input (%zu bytes):\n", len);
    printf("%s\n", input);
}

static long solve_part1(const char *input, size_t len) {
    // TODO: implement part 1 logic
    long floor = 0;
    for (long unsigned int i = 0; i < len; i++) {
        if (input[i] == '(') {
            floor++;
        } else if (input[i] == ')') {
            floor--;
        }
    }
    return (long)floor; // Return the final floor
}

static long solve_part2(const char *input, size_t len) {
    // TODO: implement part 2 logic
    long int floor = 0;
    for (long unsigned int i = 0; i < len; i++) {
        if (input[i] == '(') {
            floor++;
        } else if (input[i] == ')') {
            floor--;
        }
        if (floor == -1L) {
            return (long)(i+1); // Return position (1-based)
        }
    } 
    return -1; // Not found
}

int main(int argc, char *argv[]) {
    const char *path = (argc >1) ? argv[1] : "day01/input.txt";
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

    printf("Day 01:\n");
    printf("  Part 1: %ld (%.2f ms)\n", p1, t1 - t0);
    printf("  Part 2: %ld (%.2f ms)\n", p2, t3 - t2);

    free(input);

    return 0;
}