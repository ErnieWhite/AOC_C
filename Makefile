
# Makefile (POSIX-ish; works with gcc/clang)
# Usage:
#   make day01          # build day01
#   make run DAY=01     # run build/day01 with default input
#   make run DAY=01 INPUT=day01/sample.txt
#   make new DAY=03     # scaffold a new day03 from template
#   make all            # build all known days
#   make clean          # remove build/ artifacts

CC       := gcc
CFLAGS   := -O2 -std=c17 -Wall -Wextra -pedantic
LDFLAGS  := 
INCLUDES := -Icommon

# List your days here (append as you go)
DAYS     := 01 02

# ----- derived -----
DAY_BINS := $(addprefix build/day,$(DAYS))
COMMON_OBJS := build/aoc.o

.PHONY: all clean run new $(addprefix day,$(DAYS))

all: $(DAY_BINS)

build:
	@mkdir -p build

# Common helpers
build/aoc.o: common/aoc.c common/aoc.h | build
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

# Pattern rule: build/dayXX from dayXX/dayXX.c
build/day%: day%/day%.c day%/day%.h $(COMMON_OBJS) | build
	$(CC) $(CFLAGS) $(INCLUDES) $< $(COMMON_OBJS) -o $@ $(LDFLAGS)

# Convenience targets: day01, day02, ...
day%: build/day%
	@true

# Run a specific day; override INPUT=... if desired
run:
	@echo "Usage: make run DAY=01 [INPUT=day01/sample.txt]"
	@exit 1

run:
	@test -n "$(DAY)" || (echo "Set DAY=XX (e.g., DAY=01)"; exit 1)
	@$(MAKE) -s day$(DAY)
	@INPUT ?= day$(DAY)/input.txt
	@echo "Running Day $(DAY) with '$(INPUT)'"
	@./build/day$(DAY) "$(INPUT)"

# Scaffold a new day: make new DAY=03
new:
	@test -n "$(DAY)" || (echo "Set DAY=XX (e.g., DAY=03)"; exit 1)
	@mkdir -p day$(DAY)
	@touch day$(DAY)/input.txt day$(DAY)/sample.txt
	@[ -f day$(DAY)/day$(DAY).h ] || echo "/* day$(DAY)/day$(DAY).h */\n#ifndef DAY$(DAY)\n#define DAY$(DAY)\n#endif" > day$(DAY)/day$(DAY).h
	@[ -f day$(DAY)/day$(DAY).c ] || printf "\
	/* day$(DAY)/day$(DAY).c */\n\
	#include \"day$(DAY).h\"\n\
	#include \"../common/aoc.h\"\n\
	\n\
	void display_input(const char *input, size_t len) {\n\
	    printf(\"Input (%zu bytes):\\n\", len);\n\
		    printf(\"%s\\n\", input);\n\
	}\n\
	\n\
	static long
	int main(int argc, char *argv[]) {\n    const char *path = (argc > 1) ? argv[1] : \"day$(DAY)/input.txt\";\n    size_t len = 0; char *input = read_file(path, &len);\n    if (!input) return 1;\n    // TODO: implement\n    display_input(input, len);\n    free(input);\n    return 0;\n}\n" > day$(DAY)/day$(DAY).c
	@# Update DAYS list (manual step): edit Makefile and append $(DAY) to DAYS

clean:
	@rm -rf build
       
