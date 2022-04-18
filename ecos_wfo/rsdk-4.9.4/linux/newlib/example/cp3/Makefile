#
# Realtek Semiconductor Corp.
#
# RSDK CP3 Library
#
# Tony Wu (tonywu@realtek.com.tw)
# Jul. 07, 2006
#

#//////////////////////////////////////////////
ARCH = 4180
PROGRAM = testcp3

CC := rsdk-elf-gcc
LD := rsdk-elf-gcc

CFLAGS = -march=$(ARCH) -c -G0
IFLAGS = -I$(RSDKDIR)/include
LDFLAGS = -Wl,-N -march=$(ARCH) -T rlxsim.ld
LIBS = -lm -lc -lgcc

#//////////////////////////////////////////////
all: $(PROGRAM)

.S.o:
	$(CC) -D__ASM__ -x assembler-with-cpp $(CFLAGS) $(IFLAGS) $<

.c.o:
	$(CC) $(CFLAGS) $(IFLAGS) $<

testcp3: cp3.o
	$(LD) $(LDFLAGS) -o testcp3 cp3.o $(LIBS)

clean:
	rm -f *.o $(PROGRAM)
