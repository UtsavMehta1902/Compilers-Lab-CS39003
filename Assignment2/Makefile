a.out:	main.o	libMyLibIO.a
	cc -Wall main.o -L. -lMyLibIO

main.o:	main.c	myl.h
	cc -Wall -c main.c

libMyLibIO.a: ass2_20CS10069.o
	ar -rcs libMyLibIO.a ass2_20CS10069.o

ass2_20CS10069.o: ass2_20CS10069.c myl.h
	cc -Wall -c ass2_20CS10069.c

clean:
	rm main.o libMyLibIO.a ass2_20CS10069.o
