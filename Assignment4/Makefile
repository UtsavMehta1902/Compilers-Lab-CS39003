asgn4_20CS10068_20CS10069_output.txt: parser asgn4_20CS10068_20CS10069_test.c
	./parser < asgn4_20CS10068_20CS10069_test.c > asgn4_20CS10068_20CS10069_output.txt

parser: lex.yy.o y.tab.o asgn4_20CS10068_20CS10069.o
	gcc lex.yy.o y.tab.o asgn4_20CS10068_20CS10069.o -lfl -o parser

asgn4_20CS10068_20CS10069.o: asgn4_20CS10068_20CS10069.c
	gcc -c asgn4_20CS10068_20CS10069.c

lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

y.tab.o: y.tab.c
	gcc -c y.tab.c

lex.yy.c: asgn4_20CS10068_20CS10069.l y.tab.h
	flex asgn4_20CS10068_20CS10069.l

y.tab.c y.tab.h: asgn4_20CS10068_20CS10069.y
	bison -dty --report=all asgn4_20CS10068_20CS10069.y

clean:
	rm parser asgn4_20CS10068_20CS10069.o lex.yy.* y.tab.* y.output
