%x STRING_STATE COMMENT

%{
#include <string.h>
#include "errormsg.h"
#include "tokens.h"
#include "util.h"

YYSTYPE yylval;

int current_line = 1;
int current_column = 1;

int token_start_line;
int token_start_column;

const int INITIAL_LENGTH = 32;
char *buffer;
int capacity;

void init_buffer(void);
void update_buffer(char ch);

int comment_depth = 0;

void mark_token_start() {
  token_start_line = current_line;
  token_start_column = current_column;
}

E_Pos make_pos() {
  E_Pos pos;
  pos.first_line = token_start_line;
  pos.first_column = token_start_column;
  pos.last_line = current_line;
  pos.last_column = current_column + yyleng - 1;
  return pos;
}
%}

%option nounput noinput

space [ \t]
ws {space}+
digit [0-9]
id [_a-zA-Z]+[_a-zA-Z0-9]*

%%

[ \t\r]+   { current_column += yyleng; }
<INITIAL,COMMENT>\n { current_line++; current_column = 1; EM_newline(); continue; }

"of"        { mark_token_start(); yylval.pos = make_pos(); return OF; }
"function"  { mark_token_start(); yylval.pos = make_pos(); return FUNCTION; }
"if"        { mark_token_start(); yylval.pos = make_pos(); return IF; }
"else"      { mark_token_start(); yylval.pos = make_pos(); return ELSE; }
"let"       { mark_token_start(); yylval.pos = make_pos(); return LET; }
"in"        { mark_token_start(); yylval.pos = make_pos(); return IN; }
"end"       { mark_token_start(); yylval.pos = make_pos(); return END; }
"for"       { mark_token_start(); yylval.pos = make_pos(); return FOR; }
"while"     { mark_token_start(); yylval.pos = make_pos(); return WHILE; }
"to"        { mark_token_start(); yylval.pos = make_pos(); return TO; }
"break"     { mark_token_start(); yylval.pos = make_pos(); return BREAK; }
"then"      { mark_token_start(); yylval.pos = make_pos(); return THEN; }
"array"     { mark_token_start(); yylval.pos = make_pos(); return ARRAY; }
"type"      { mark_token_start(); yylval.pos = make_pos(); return TYPE; }
"nil"       { mark_token_start(); yylval.pos = make_pos(); return NIL; }
"do"        { mark_token_start(); yylval.pos = make_pos(); return DO; }
"var"       { mark_token_start(); yylval.pos = make_pos(); return VAR; }

"="       { mark_token_start(); yylval.pos = make_pos(); return EQ; }
"/"       { mark_token_start(); yylval.pos = make_pos(); return DIVIDE; }
"<"       { mark_token_start(); yylval.pos = make_pos(); return LT; }
"<>"      { mark_token_start(); yylval.pos = make_pos(); return NEQ; }
"&"       { mark_token_start(); yylval.pos = make_pos(); return AND; }
"+"       { mark_token_start(); yylval.pos = make_pos(); return PLUS; }
":"       { mark_token_start(); yylval.pos = make_pos(); return COLON; }
">="      { mark_token_start(); yylval.pos = make_pos(); return GE; }
"-"       { mark_token_start(); yylval.pos = make_pos(); return MINUS; }
":="      { mark_token_start(); yylval.pos = make_pos(); return ASSIGN; }
"|"       { mark_token_start(); yylval.pos = make_pos(); return OR; }
"("       { mark_token_start(); yylval.pos = make_pos(); return LPAREN; }
")"       { mark_token_start(); yylval.pos = make_pos(); return RPAREN; }
"{"       { mark_token_start(); yylval.pos = make_pos(); return LBRACE; }
"}"       { mark_token_start(); yylval.pos = make_pos(); return RBRACE; }
"<="      { mark_token_start(); yylval.pos = make_pos(); return LE; }
"*"       { mark_token_start(); yylval.pos = make_pos(); return TIMES; }
">"       { mark_token_start(); yylval.pos = make_pos(); return GT; }
","       { mark_token_start(); yylval.pos = make_pos(); return COMMA; }
"["       { mark_token_start(); yylval.pos = make_pos(); return LBRACK; }
"]"       { mark_token_start(); yylval.pos = make_pos(); return RBRACK; }
";"       { mark_token_start(); yylval.pos = make_pos(); return SEMICOLON; }
"."       { mark_token_start(); yylval.pos = make_pos(); return DOT; }

{digit}+ {
  mark_token_start();
  yylval.ival = atoi(yytext);
  yylval.pos = make_pos();
  current_column += yyleng;
  return INT;
}

{id} {
  mark_token_start();
  yylval.sval = strdup(yytext);
  yylval.pos = make_pos();
  current_column += yyleng;
  return ID;
}

"\"" {
  mark_token_start();
  init_buffer();
  current_column += yyleng;
  BEGIN(STRING_STATE);
}

"/*" {
  mark_token_start();
  comment_depth++;
  current_column += yyleng;
  BEGIN(COMMENT);
}

"*/" {
  mark_token_start();
  EM_error(make_pos(), "Comment closed before it began");
  yyterminate();
}

. { mark_token_start(); EM_error(make_pos(), "Illegal token"); current_column += yyleng; }

<STRING_STATE>\" {
  current_column += yyleng;
  BEGIN(INITIAL);
  yylval.sval = strdup(buffer);
  yylval.pos = make_pos();
  return STRING;
}

<STRING_STATE>\n {
  EM_error(make_pos(), "Newline in a string");
  yyterminate();
}

<STRING_STATE>\\[0-9]+ {
  EM_error(make_pos(), "Bad escape sequence!");
  yyterminate();
}

<STRING_STATE>\\n { update_buffer('\n'); current_column += yyleng; }
<STRING_STATE>\\t { update_buffer('\t'); current_column += yyleng; }
<STRING_STATE>\\\" { update_buffer('"'); current_column += yyleng; }
<STRING_STATE>\\\\ { update_buffer('\\'); current_column += yyleng; }
<STRING_STATE>\\[ \t\n\f]+\\ {
  for (int i = 0; yytext[i]; i++) {
    if (yytext[i] == '\n') EM_newline();
  }
  current_column += yyleng;
  continue;
}

<STRING_STATE><<EOF>> {
  EM_error(make_pos(), "End of file reached before string's ending quote");
  yyterminate();
}

<STRING_STATE>[^\\\n\"]* {
  char *yptr = yytext;
  while (*yptr) {
    update_buffer(*yptr++);
  }
  current_column += yyleng;
}

<COMMENT>"/*" { comment_depth++; current_column += yyleng; continue; }
<COMMENT>"*/" {
  comment_depth--;
  if (comment_depth == 0) BEGIN(INITIAL);
  current_column += yyleng;
}
<COMMENT><<EOF>> {
  EM_error(make_pos(), "EOF reached without finishing comment");
  yyterminate();
}
<COMMENT>. { current_column += yyleng; }

%%

int yywrap() {
  return 1;
}

void init_buffer(void) {
  buffer = malloc_checked(INITIAL_LENGTH);
  buffer[0] = 0;
  capacity = INITIAL_LENGTH;
}

void update_buffer(char ch) {
  size_t new_length = strlen(buffer) + 1;
  if (new_length == capacity) {
    char *temp;
    capacity *= 2;
    temp = malloc_checked(capacity);
    memcpy(temp, buffer, new_length);
    free(buffer);
    buffer = temp;
  }
  buffer[new_length - 1] = ch;
  buffer[new_length] = 0;
}


