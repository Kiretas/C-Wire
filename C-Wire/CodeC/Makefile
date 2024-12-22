all: code sort

code: code.o consumer.o rotation.o insertion.o tools.o
	gcc -o code code.o consumer.o rotation.o insertion.o tools.o

code.o: code.c consumer.h insertion.h
	gcc -o code.o -c code.c

consumer.o: consumer.c consumer.h
	gcc -o consumer.o -c consumer.c

rotation.o: rotation.c rotation.h consumer.h tools.h
	gcc -o rotation.o -c rotation.c

insertion.o: insertion.c insertion.h rotation.h consumer.h tools.h
	gcc -o insertion.o -c insertion.c

tools.o: tools.c tools.h
	gcc -o tools.o -c tools.c

sort: sort.o consumer_sort.o rotation_sort.o insertion_sort.o tools_sort.o
	gcc -o sort sort.o consumer_sort.o rotation_sort.o insertion_sort.o tools_sort.o

sort.o: sort.c consumer_sort.h insertion_sort.h
	gcc -o sort.o -c sort.c

consumer_sort.o: consumer_sort.c consumer_sort.h
	gcc -o consumer_sort.o -c consumer_sort.c

rotation_sort.o: rotation_sort.c rotation_sort.h consumer_sort.h tools_sort.h
	gcc -o rotation_sort.o -c rotation_sort.c

insertion_sort.o: insertion_sort.c insertion_sort.h rotation_sort.h consumer_sort.h tools_sort.h
	gcc -o insertion_sort.o -c insertion_sort.c

tools_sort.o: tools_sort.c tools_sort.h
	gcc -o tools_sort.o -c tools_sort.c

clean:
	rm -f *.o code sort
