/* This file is intentionally empty.  You should fill it in with your
   solution to the programming exercise. */

#include <stdio.h>
#include "slp.h"
#include "interp.h"
#include "prog1.h"

int main(void) {
    printf("Testing table functions\n");
    // Create a table and add some entries
    Table t = make_Table("a", 1, NULL);
    t = update(t, "b", 2);
    t = update(t, "c", 3);

    // Print the table
    printf("Initial table:\n");
    printTable(t);

    // Lookup values
    printf("Lookup 'a': %d\n", lookup(t, "a"));
    printf("Lookup 'b': %d\n", lookup(t, "b"));
    printf("Lookup 'c': %d\n", lookup(t, "c"));

    printf("\nTest interpretExp with a simple expression\n");
    AExp exp = make_AOpExp(make_AIdExp("a"), A_PLUS, make_ANumExp(5));
    IntAndTable result = interpretExp(exp, t);
    printf("Result of expression 'a + 5': %d\n", result->i);
    printTable(result->t);

    printf("\nTest interpretStm with a simple assignment statement\n");
    AStm stm = make_AAssignStm("d", make_AOpExp(make_AIdExp("b"), A_TIMES, make_ANumExp(4)));
    t = interpretStm(stm, t);
    printf("Table after 'd = b * 4':\n");
    printTable(t);

    printf("\nTest interpretStm with a print statement\n");
    AStm printStm = make_APrintStm(make_ALastExpList(make_AIdExp("d")));
    t = interpretStm(printStm, t);
    printf("Table after 'print(d)':\n");
    printTable(t);


    printf("\nProgram 1:\n");
    AStm program = prog();
    interpret(program);

    printf("\nProgram 2:\n");
    AStm program2 = prog2();
    interpret(program2);
    return 0;

}