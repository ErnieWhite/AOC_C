# Makefile (POSIX-ish; works with gcc/clang)
# This repository contains Advent of Code solutions in C (one "day" per folder).
#
# What this Makefile does:
#  - Builds each day's binary into `build/dayXX` using a simple, portable rule.
#  - Compiles shared helpers into `build/aoc.o` and links them into each day binary.
#  - Provides convenience targets to run a day's binary with its input and to scaffold a new day.
#
# Important variables:
#  CC       - compiler (default: gcc)
#  CFLAGS   - compiler flags (default: -O2 -std=c17 -Wall -Wextra -pedantic)
#  LDFLAGS  - linker flags (empty by default)
#  INCLUDES - include flags for headers (default: -Icommon)
#  DAYS     - list of two-digit day identifiers (e.g., 01 02). Append new days here.
#
# Targets (summary):
#  all        - builds all day binaries listed in $(DAYS)
#  build      - ensures the `build/` directory exists (internal prerequisite)
#  build/aoc.o - compiles shared helper into `build/`
#  build/day% - pattern rule that compiles `dayXX/dayXX.c` into `build/dayXX`
#  day%       - convenience target depending on `build/day%` (e.g., `make day01`)
#  run        - runs a day's binary with INPUT; Usage: `make run DAY=01 [INPUT=day01/sample.txt]`
#  new        - scaffolds a new day directory and placeholder files; Usage: `make new DAY=03`
#  clean      - removes `build/` artifacts
#
# Notes and tips:
#  - After creating a new day with `make new DAY=03`, add the two-digit number to `DAYS`.
#  - The build rules are intentionally simple; override `CFLAGS`/`LDFLAGS` as needed for testing or profiling.
#  - The `run` target defaults to `dayXX/input.txt` if `INPUT` is not set.
#
# Example usage:
#  make day01
#  make run DAY=01
#  make run DAY=01 INPUT=day01/sample.txt
#  make new DAY=03

SHELL   := /bin/sh
CC      := gcc
CFLAGS  := -O2 -std=c17 -Wall -Wextra -pedantic
LDFLAGS :=
INCLUDES := -Icommon

# Auto-discover days as two-digit directories named dayNN
DAYS := $(sort $(patsubst day%,%,$(notdir $(wildcard day[0-9][0-9]))))
DAY_BINS := $(addprefix build/day,$(DAYS))

# Compile every .c in common/ into build/<name>.o
COMMON_SRCS := $(wildcard common/*.c)
COMMON_OBJS := $(patsubst common/%.c,build/%.o,$(COMMON_SRCS))

.PHONY: all help clean new run day%

all: $(DAY_BINS)

build:
	@mkdir -p build

# Build common helpers
build/%.o: common/%.c | build
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Pattern rule: build/dayXX from dayXX/dayXX.c
# Generate explicit per-day rules using `define`+`eval`. This avoids pattern
# edge-cases with multiple `%` tokens and makes dependencies explicit.
define DAY_RULE
build/day$(1): day$(1)/day$(1).c day$(1)/day$(1).h $(COMMON_OBJS) | build
	$(CC) $(CFLAGS) $(INCLUDES) $$< $(COMMON_OBJS) -o $$@ $(LDFLAGS)
endef
$(foreach d,$(DAYS),$(eval $(call DAY_RULE,$(d))))

# Convenience targets: day01, day02, ...
day%: build/day%
	@true

# Run a specific day; override INPUT=... if desired
run:
	@test -n "$(DAY)" || (echo "Set DAY=XX (e.g., DAY=01)"; exit 1)
	@$(MAKE) -s day$(DAY)
	@INPUT=$${INPUT:-day$(DAY)/input.txt}; \
		echo "Running Day $(DAY) with '$$INPUT'"; \
		./build/day$(DAY) "$$INPUT"

# Scaffold a new day: make new DAY=03
new:
	@test -n "$(DAY)" || (echo "Set DAY=XX (e.g., DAY=03)"; exit 1)
	@mkdir -p day$(DAY)
	@touch day$(DAY)/input.txt day$(DAY)/sample.txt
	@[ -f day$(DAY)/day$(DAY).h ] || echo "/* day$(DAY)/day$(DAY).h */\n#ifndef DAY$(DAY)\n#define DAY$(DAY)\n#endif" > day$(DAY)/day$(DAY).h
	@[ -f day$(DAY)/day$(DAY).c ]
	/* day$(DAY)/day$(DAY).c */
	#include "day$(DAY).h"
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
		const char *path = (argc >1) ? argv[1] : "day$(DAY)/input.txt";
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
		printf("Day $(DAY):\n");
		printf("  Part 1: %ld (%.2f ms)\n");
		printf("  Part 2: %ld (%.2f ms)\n");
		
		free(input);
		
		return 0;
	}
	EOF	

	@# Update DAYS list (manual step): edit Makefile and append $(DAY) to DAYS

help:
	@echo "Usage:"; \
	echo "  make            - build all discovered days"; \
	echo "  make DAY=01 run - build & run a day (defaults to day01/input.txt)"; \
	echo "  make new DAY=03  - scaffold a new day"; 
	@echo "\nDiscovered days: $(DAYS)"

clean:
	@rm -rf build
       