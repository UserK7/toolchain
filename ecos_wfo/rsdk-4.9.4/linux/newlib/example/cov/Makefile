#
# Realtek Semiconductor Corp.
#
# RSDK RLXCOV Library
#
# Tony Wu (tonywu@realtek.com.tw)
# Jul. 07, 2006
#

#//////////////////////////////////////////////
ARCH ?= 4181
PROGRAM := testcov

CC := rsdk-elf-gcc
LD := rsdk-elf-gcc
OBJS := rlxcov_crt0.o irq.o cov.o

ARCH_FLAGS := -march=$(ARCH)
CFLAGS := -G0 -frlxcov -ftest-coverage -fprofile-arcs
LDFLAGS := -Wl,-N -T rlxcov_sim.ld -ftest-coverage -fprofile-arcs
#//////////////////////////////////////////////
all: $(PROGRAM)

cov.o: cov.c
	$(CC) $(ARCH_FLAGS) $(CFLAGS) -c $<

irq.o: irq.c
	$(CC) $(ARCH_FLAGS) -c $<

rlxcov_crt0.o: rlxcov_crt0.S
	$(CC) $(ARCH_FLAGS) -c $<

$(PROGRAM): $(OBJS)
	$(LD) $(ARCH_FLAGS) $(LDFLAGS) -o $@ $^

.PHONY: clean
clean:
	-rm *.o *.gcno *.gcda *.gcov $(PROGRAM)
