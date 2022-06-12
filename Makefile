CC=gcc
CFLAGS=-g
BISON=bison
BFLAGS=-v -d -Wcounterexamples
FLEX=flex

test.exe: main.c structures.c phobic.tab.c lex.yy.c
	$(CC) $(CLFAGS) main.c structures.c phobic.tab.c lex.yy.c -o test.exe

lex.yy.c: phobic.l
	$(FLEX) phobic.l

phobic.tab.c: phobic.y
	$(BISON) $(BFLAGS) phobic.y

.PHONY: clean

clean:
	rm -rf phobic.output phobic.tab.c phobic.tab.h lex.yy.c test.exe
