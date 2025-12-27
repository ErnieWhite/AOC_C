/* common/aoc.c */
#include "aoc.h"

char *read_file(const char * path, size_t *len) {
    FILE *f = fopen(path, "rb");
    if (!f) { perror(path); return NULL; }

    /* move to end and get size */
    if (fseek(f, 0, SEEK_END) != 0) { perror("ftell"); fclose(f); return NULL; }
    long n = ftell(f);  /* file size in bytes */
    if (n < 0) { perror("ftell"); fclose(f); return NULL; }

    fseek(f, 0, SEEK_SET); /* rewind */
    char *buf = (char *)malloc((size_t)n + 1); /* +1 for null terminator */
    if (!buf) { fclose(f); return NULL; } /* malloc failed */

    /* Read file only if there are bytes to read; allow zero-length files */
    if ((size_t)n > 0) {
        size_t got = fread(buf, 1, (size_t)n, f); /* read file into buffer */
        if (got != (size_t)n) {
            free(buf);
            fclose(f);
            return NULL;
        }
    }

    fclose(f); /* close file */

    buf[n] = '\0'; /* null terminate */
    if (len) *len = (size_t)n; /* set length if requested */

    return buf;
}

void trim_newline(char *s) {
    if (!s) return;
    size_t n = strlen(s);
    while (n && (s[n-1]== '\n' || s[n-1] == '\r')) {
        s[--n] = '\0';
    }
}

double now_ms() {
    return (double)clock() * 1000.0 / (double)CLOCKS_PER_SEC;
}

double print_execution_time(clock_t start, clock_t end) {
    double duration_ms = ((double)(end - start)) * 1000.0 / (double)CLOCKS_PER_SEC;
    printf("Execution time: %.3f ms\n", duration_ms);
    return duration_ms;
}
