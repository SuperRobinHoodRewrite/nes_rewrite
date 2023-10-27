SOURCES = src/main.asm

CA      = ca65
CC      = ld65
LDFLAGS = -vm -m $(PROGRAM).map -C memory.cfg  --dbgfile $(PROGRAM).dbg -Ln $(PROGRAM).labels.txt

.PHONY: all clean emu

PROGRAM = robin.nes

$(PROGRAM): $(SOURCES:.asm=.o)
	$(CC) $(LDFLAGS) -o $@ $^

%.o: %.asm
	$(CA) -g -o $@ $<

clean:
	$(RM) $(SOURCES:.asm=.o) $(SOURCES:.asm=.d) $(PROGRAM) $(PROGRAM).map $(PROGRAM).dbg $(PROGRAM).labels.txt

emu:
	fceux ./robin.nes
