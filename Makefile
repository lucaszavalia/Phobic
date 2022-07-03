CC=g++
CFLAG=-g
FL=flex
B=bison
BFLAG=-v -d -Wcounterexamples

all:
	$(FL) -o scanner.cpp scanner.l
	$(B) $(BFLAGS) -o parser.cpp parser.y
	$(CC) $(CFLAGS) main.cpp scanner.cpp parser.cpp repl.cpp -o out.exe

clean:
	rm -rf scanner.cpp parser.cpp parser.hpp location.hh stack.hh position.hh out.exe
