#pragma once

#include <assert.h>
#include <stdbool.h>

typedef char * string;

void * malloc_checked(int);
string make_String(char *);

typedef struct UBoolList_ * UBoolList;
struct UBoolList_ {
    bool head;
    UBoolList tail;
};

UBoolList make_UBoolList(bool head, UBoolList tail);

