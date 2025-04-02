/*
 * errormsg.c - functions used in all phases of the compiler to give
 *              error messages about the Tiger program.
 *
 */

 #include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>

#include "errormsg.h"
#include "util.h"

bool EM_any_errors = false;
static string file_name = "";
extern FILE *yyin;
static int line_num = 1;

void EM_newline() {
  line_num++;
}

void EM_error(E_Pos pos, string message, ...) {
  va_list ap;
  EM_any_errors = true;

  if (file_name) {
    fprintf(stderr, "%s:", file_name);
  }

  fprintf(stderr, "%d.%d-%d.%d: ",
          pos.first_line, pos.first_column,
          pos.last_line, pos.last_column);

  va_start(ap, message);
  vfprintf(stderr, message, ap);
  va_end(ap);
  fprintf(stderr, "\n");
}

void EM_reset(string fname) {
  EM_any_errors = false;
  file_name = fname;
  line_num = 1;
  yyin = fopen(fname, "r");
  if (!yyin) {
    perror("Cannot open input file");
    exit(EXIT_FAILURE);
  }
}
