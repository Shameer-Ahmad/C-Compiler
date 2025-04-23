CC = gcc
FLAGS = -Wall -Werror -std=c99 -D_XOPEN_SOURCE=700 -g
APP = lextest

parser: util.o errormsg.o symbol.o table.o absyn.o lex.yy.o tiger.tab.o main.c
	gcc $(FLAGS) $^ -o $@

$(APP): driver.o lex.yy.o errormsg.o util.o
	$(CC) $(FLAGS) $^ -o $@

tiger.tab.o: tiger.tab.c
	gcc -c $^ -o $@

driver.o: driver.c tokens.h errormsg.h util.h
	$(CC) $(FLAGS) -c $<

absyn.o: absyn.c
	gcc -c $^ -o $@

symbol.o: symbol.c
	gcc -c $^ -o $@

table.o: table.c
	gcc -c $^ -o $@

errormsg.o: errormsg.c errormsg.h util.h
	$(CC) $(FLAGS) -c $<

tiger.tab.c: tiger.grm
	bison -dv $^ -o $@

lex.yy.o: lex.yy.c tokens.h errormsg.h util.h
	$(CC) $(FLAGS) -c $<

util.o: util.c util.h
	$(CC) $(FLAGS) -c $<

lex.yy.c: tiger.lex
	lex $^

clean: 
	rm -f $(APP) parser *.o
