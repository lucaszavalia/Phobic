CC=g++
CFLAGS=-g
FL=flex
B=bison
BFLAGS=-v -d -Wcounterexamples

all:
	$(FL) -o scanner.cpp scanner.l
	$(B) $(BFLAGS) -o parser.cpp parser.y
	$(CC) $(CFLAGS) main.cpp scanner.cpp parser.cpp repl.cpp data.cpp semantics.cpp -g -o out.exe

clean:
	rm -rf scanner.cpp parser.cpp parser.hpp location.hh stack.hh position.hh AST.dot AST.pdf out.exe

reset:
	rm -rf AST.dot AST.pdf

doc:
	dot -Tpdf AST.dot > AST.pdf
