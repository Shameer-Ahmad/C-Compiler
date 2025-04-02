#include <stdio.h>
#include <stdlib.h>

#include "errormsg.h"
#include "tokens.h"
#include "util.h"

extern YYSTYPE yylval;

int yylex(); /* prototype for the lexing function */

const string token_names[] = {
    "ID", "STRING", "INT", "COMMA", "COLON", "SEMICOLON", "LPAREN",
    "RPAREN", "LBRACK", "RBRACK", "LBRACE", "RBRACE", "DOT", "PLUS",
    "MINUS", "TIMES", "DIVIDE", "EQ", "NEQ", "LT", "LE", "GT", "GE",
    "AND", "OR", "ASSIGN", "ARRAY", "IF", "THEN", "ELSE", "WHILE", "FOR",
    "TO", "DO", "LET", "IN", "END", "OF", "BREAK", "NIL", "FUNCTION",
    "VAR", "TYPE"
};

string token_name(int token) {
    return token < ID || token > TYPE ? "BAD_TOKEN" : token_names[token - 257];
}

int main(int argc, char ** argv) {
    int token;
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file_name>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    EM_reset(argv[1]);
    while ((token = yylex())) {
        switch (token) {
            case ID:
            case STRING:
                printf("%10s %4d.%d-%d.%d %s\n",
                       token_name(token),
                       pos.first_line, pos.first_column,
                       pos.last_line, pos.last_column,
                       yylval.sval ? yylval.sval : "(null)");
                break;
            case INT:
                printf("%10s %4d.%d-%d.%d %d\n",
                       token_name(token),
                       pos.first_line, pos.first_column,
                       pos.last_line, pos.last_column,
                       yylval.ival);
                break;
            default:
                printf("%10s %4d.%d-%d.%d\n",
                       token_name(token),
                       pos.first_line, pos.first_column,
                       pos.last_line, pos.last_column);
        }
    }
    return EXIT_SUCCESS;
}



