output.txt: a.out ass3_20CS10068_20CS10069_test.c
	./a.out < ass3_20CS10068_20CS10069_test.c > output.txt
	cat output.txt

a.out: lex.yy.c ass3_20CS10068_20CS10069.c
	cc lex.yy.c ass3_20CS10068_20CS10069.c -lfl

lex.yy.c: ass3_20CS10068_20CS10069.l 
	flex ass3_20CS10068_20CS10069.l

clean:
	rm a.out lex.yy.c output.txt