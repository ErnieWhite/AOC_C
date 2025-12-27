/* common/aoc.h */
#ifndef AOC_H
#define AOC_H

#define _POSIX_C_SOURCE 199309L

#include <stddef.h> // for size_t
#include <stdio.h>  // for FILE
#include <stdlib.h> // for malloc, free
#include <string.h> // for strlen, strcpy
#include <time.h>   // for clock_t, clock, CLOCKS_PER_SEC

char *read_file(const char *path, size_t *len);
void trim_newline(char *s);
double print_execution_time(clock_t start, clock_t end);
double now_ms();

#endif // AOC_H