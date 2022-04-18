#
# Realtek Semiconductor Corp.
#
# RSDK Profiler Library
#
# Tony Wu (tonywu@realtek.com.tw)
# Jul. 07, 2006
#

#//////////////////////////////////////////////
ARCH = 4181
PROGRAM = testprof

CC := rsdk-elf-gcc
LD := rsdk-elf-gcc

CFLAGS = -march=$(ARCH) -c -G0 -pg -DRLX_UNCACHEABLE
IFLAGS = -I$(RSDKDIR)/include
LDFLAGS = -Wl,-N -march=$(ARCH) -T rlxsim.ld
LIBS = -lm -lc -lgcc

#//////////////////////////////////////////////
all: $(PROGRAM)

.S.o:
	$(CC) -D__ASM__ -x assembler-with-cpp $(CFLAGS) $(IFLAGS) $<

.c.o:
	$(CC) $(CFLAGS) $(IFLAGS) $<

testprof: prof.o rlx_prof_int.o
	$(LD) $(LDFLAGS) -o testprof prof.o rlx_prof_int.o $(LIBS)

clean:
	rm -f *.o $(PROGRAM)
