/* This file is intentionally empty.  You should fill it in with your
   solution to the programming exercise. */

#include <stdio.h>
#include "maxargs.h"
#include "prog1.h"

int main() {
    A_stm prog_stm = prog();
    int max_args = maxargs(prog_stm);
    printf("Maximum number of arguments in any print statement: %d\n", max_args);
    return 0;
}