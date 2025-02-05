#ifndef INTERP_H
#define INTERP_H

#include <stdlib.h>
#include "util.h"

typedef struct Table_ * Table;
struct Table_ {
    string id;
    int value;
    Table tail;
};

Table make_Table(string id, int value, Table tail);

typedef struct IntAndTable_ * IntAndTable;
struct IntAndTable_ {
    int i;
    Table t;
};

IntAndTable make_IntAndTable(int i, Table t);

void interpret(AStm stm);

Table interpretStm(AStm s, Table t);

IntAndTable interpretExp(AExp e, Table t);

IntAndTable interpretExpList(AExpList expList, Table t);

Table update(Table t, string id, int value);

int lookup(Table t, string key);

void printTable(Table t);

#endif /* INTERP_H */