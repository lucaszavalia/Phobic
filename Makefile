CC=g++
CFLAGS=-g -c 
FL=flex
B=bison
BFLAGS=-v -d -Wcounterexamples
OBJ=obj
SRC=src

all: $(OBJ)/main.o $(OBJ)/repl.o $(OBJ)/parser.o $(OBJ)/scanner.o $(OBJ)/data.o
	$(CC) $(OBJ)/main.o $(OBJ)/repl.o $(OBJ)/data.o $(OBJ)/parser.o $(OBJ)/scanner.o -o out.exe

$(OBJ)/main.o: $(SRC)/main.cpp $(OBJ)/parser.o $(OBJ)/scanner.o
	$(CC) $(CFLAGS) $(SRC)/main.cpp -o $(OBJ)/main.o

$(OBJ)/repl.o: $(SRC)/repl.cpp $(SRC)/repl.h $(SRC)/parser.cpp $(SRC)/scanner.cpp
	$(CC) $(CFLAGS) $(SRC)/repl.cpp -o $(OBJ)/repl.o

$(OBJ)/data.o: $(SRC)/data.cpp $(SRC)/data.hpp
	$(CC) $(CFLAGS) $(SRC)/data.cpp -o $(OBJ)/data.o

$(OBJ)/parser.o: $(SRC)/parser.y
	$(B) $(BFLAGS) -o $(SRC)/parser.cpp $(SRC)/parser.y
	$(CC) $(CFLAGS) $(SRC)/parser.cpp -o $(OBJ)/parser.o

$(OBJ)/scanner.o: $(SRC)/scanner.l
	$(FL) -o $(SRC)/scanner.cpp $(SRC)/scanner.l
	$(CC) $(CFLAGS) $(SRC)/scanner.cpp -o $(OBJ)/scanner.o

clean:
	rm -rf $(SRC)/scanner.cpp $(SRC)/parser.cpp $(SRC)/parser.hpp $(SRC)/parser.output $(SRC)/location.hh $(SRC)/stack.hh $(SRC)/position.hh AST.dot AST.pdf out.exe
	rm -rf obj/*.o

reset:
	rm -rf AST.dot AST.pdf

doc:
	dot -Tpdf AST.dot > AST.pdf
