CC = gcc
FLAGS = -Wall -Werror -std=c99 -g

slp: main.o prog1.o slp.o util.o interp.o
	$(CC) $(FLAGS) $^ -o $@

main.o: main.c slp.h util.h interp.h prog1.h
	$(CC) $(FLAGS) -c $<

prog1.o: prog1.c slp.h util.h
	$(CC) $(FLAGS) -c $<

slp.o: slp.c slp.h util.h
	$(CC) $(FLAGS) -c $<

interp.o: interp.c interp.h slp.h util.h
	$(CC) $(FLAGS) -c $<

util.o: util.c util.h
	$(CC) $(FLAGS) -c $<

clean:
	rm -f slp *.o

