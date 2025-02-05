#include <stdio.h>
#include <string.h>
#include "slp.h"
#include "interp.h"
#include "util.h"

Table make_Table(string id, int value, Table tail) {
    Table t = malloc(sizeof(*t));
    t->id = id;
    t->value = value;
    t->tail = tail;
    return t;
}

IntAndTable make_IntAndTable(int i, Table t) {
    IntAndTable it = malloc_checked(sizeof(*it));
    it->i = i;
    it->t = t;
    return it;
}

void interpret(AStm stm) {
    interpretStm(stm, NULL);
}

Table interpretStm(AStm s, Table t) {
    IntAndTable it;

    switch (s->kind) {
        case A_COMPOUND_STM:
            t = interpretStm(s->u.compound.stm1, t);
            t = interpretStm(s->u.compound.stm2, t);
            return t;

        case A_ASSIGN_STM:
            it = interpretExp(s->u.assign.exp, t);
            t = update(it->t, s->u.assign.id, it->i);
            printTable(t); // Print the table after assignment
            return t;

        case A_PRINT_STM:
            it = interpretExpList(s->u.print.exps, t);
            return it->t;

        default:
            assert(!"Invalid AStm kind!");
    }
    return t;
}

IntAndTable interpretExp(AExp e, Table t) {
    switch (e->kind) {
        case A_ID_EXP:
            return make_IntAndTable(lookup(t, e->u.id), t);
        
        case A_NUM_EXP:
            return make_IntAndTable(e->u.num, t);

        case A_OP_EXP: {
            int left, right;
            IntAndTable it_tmp;

            it_tmp = interpretExp(e->u.op.left, t);
            left = it_tmp->i;
            it_tmp = interpretExp(e->u.op.right, it_tmp->t);
            right = it_tmp->i;

            int value;
            switch (e->u.op.oper) {
                case A_PLUS: value = left + right; break;
                case A_MINUS: value = left - right; break;
                case A_TIMES: value = left * right; break;
                case A_DIV: value = left / right; break;
                default: assert(!"Invalid ABinop value!");
            }
            return make_IntAndTable(value, it_tmp->t);
        }

        case A_ESEQ_EXP:
            t = interpretStm(e->u.eseq.stm, t);
            return interpretExp(e->u.eseq.exp, t);

        default:
            assert(!"Invalid AExp kind!");
    }
}

IntAndTable interpretExpList(AExpList expList, Table t) {
    IntAndTable it;

    switch (expList->kind) {
        case A_PAIR_EXP_LIST:
            it = interpretExp(expList->u.pair.head, t);
            printf("%d ", it->i);
            return interpretExpList(expList->u.pair.tail, it->t);

        case A_LAST_EXP_LIST:
            it = interpretExp(expList->u.last, t);
            printf("%d\n", it->i);
            return it;

        default:
            assert(!"Invalid AExpList kind!");
    }
}

Table update(Table t, string id, int value) {
    return make_Table(id, value, t);
}

int lookup(Table t, string key) {
    Table temp = t;
    while (temp != NULL) {
        if (strcmp(temp->id, key) == 0) {
            return temp->value;
        }
        temp = temp->tail;
    }
    assert(!"Lookup failed: key not found!");
    return -1;
}

void printTable(Table t) {
    Table temp = t;
    while (temp != NULL) {
        printf("%s = %d\n", temp->id, temp->value);
        temp = temp->tail;
    }
    printf("----\n");
}