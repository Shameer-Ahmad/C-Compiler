%x STRING_STATE COMMENT

%{
#include <string.h>

#include "errormsg.h"
#include "tokens.h"
#include "util.h"


int char_pos = 1;

int comment_depth = 0;

const int INITIAL_LENGTH = 32;
char *buffer;
int capacity;

void init_buffer(void);
void adjust(void);
void update_buffer(char ch);

%}

%option nounput noinput

space [ \t]
ws {space}+
digit [0-9]
id      [_a-zA-Z]+[_a-zA-Z0-9]*

%%

 /* Whitespace */
[ \t\r]+  { adjust(); }

{ws}        { adjust(); continue; }
<INITIAL,COMMENT>\n	        { adjust(); EM_newline(); continue; }


   /* Keywords */
of        {adjust(); return OF;}
function  {adjust(); return FUNCTION;}
if        {adjust(); return IF;}
else      {adjust(); return ELSE;}
let       {adjust(); return LET;}
in        {adjust(); return IN;}
end       {adjust(); return END;}
for       {adjust(); return FOR;}
while     {adjust(); return WHILE;}
to        {adjust(); return TO;}
break     {adjust(); return BREAK;}
then      {adjust(); return THEN;}
array     {adjust(); return ARRAY;}
type      {adjust(); return TYPE;}
nil       {adjust(); return NIL;}
do        {adjust(); return DO;}
var       {adjust(); return VAR;}

  /* Punctuation */
"="   {adjust(); return EQ;}
"/"   {adjust(); return DIVIDE;}
"<"   {adjust(); return LT;}
"<>"  {adjust(); return NEQ;}
"&"   {adjust(); return AND;}
"+"   {adjust(); return PLUS;}
":"   {adjust(); return COLON;}
">="  {adjust(); return GE;}
"-"   {adjust(); return MINUS;}
":="  {adjust(); return ASSIGN;}
"|"   {adjust(); return OR;}
"("   {adjust(); return LPAREN;}
")"   {adjust(); return RPAREN;}
"{"   {adjust(); return LBRACE;}
"}"   {adjust(); return RBRACE;}
"<="  {adjust(); return LE;}
"*"   {adjust(); return TIMES;}
">"   {adjust(); return GT;}
","   {adjust(); return COMMA;}
"["   {adjust(); return LBRACK;}
"]"   {adjust(); return RBRACK;}
";"   {adjust(); return SEMICOLON;}
"."   {adjust(); return DOT;}


 /* Identifiers */
[_a-zA-Z]+[_a-zA-Z0-9]*  {
                         adjust();
                         yylval.sval = strdup(yytext);
                         return ID;
                       }

 /* Integers */
{digit}+ {
          adjust();
          yylval.ival = atoi(yytext);
          return INT;
       }

  /* Beginning of a string */
\" {
     adjust();
     init_buffer();
     BEGIN(STRING_STATE);
   }

  /* Beginning of a comment */
"/*" {
       adjust();
       comment_depth++;
       BEGIN(COMMENT);
     }

  /* End of a comment before finding the start of a comment. Report error */
"*/" {
       adjust();
       EM_error(EM_token_pos, "Comment closed before it began");
       yyterminate();
     }

 /* Illegal token */
.           { adjust(); EM_error(EM_token_pos, "Illegal token"); }

<STRING_STATE>{

    /* Terminating string:  Buffer pointer with zero and copy its value */
    \" {
          adjust();
          BEGIN(INITIAL);
          yylval.sval = strdup(buffer);
          return STRING;
       }

    /* Newline in a string produces an error */
    \n {
         adjust();
         EM_error(EM_token_pos, "Newline in a string");
         yyterminate();
       }


    /* Strings with \0455 are invalid */
    \\[0-9]+ {
               adjust();
               EM_error(EM_token_pos, "Bad escape sequence!");
               yyterminate();
             }

    /* Newline escape sequence. */
    \\n {
          adjust();
          update_buffer('\n');
        }

    /* Tab escape sequence. */
    \\t {
          adjust();
          update_buffer('\t');
        }


    /* The double-quote character (") inside a string. */
    "\\\"" {
             adjust();
             update_buffer('"');
           }

    /* The backslash character (\) inside a string. */
    "\\\\" {
             adjust();
             update_buffer('\\');
           }

    /* This matches a backslash (\) followed by one or more formatting characters 
       (space, tab, newline, formfeed), followed by another backslash (\). */
    \\[ \t\n\f]+\\ {
                     adjust();
                     /* Handle newlines correctly. */
                     int i;
                     for (i = 0; yytext[i]; i++) {
                        if (yytext[i] == '\n') {
                          EM_newline();
                        }
                     }
                     continue;
                   }

    /* Catches EOF in the string state. */
    <<EOF>> {
              EM_error(EM_token_pos, "End of file reached before string's ending quote");
              yyterminate();
            }

    /* Normal text. */
    [^\\\n\"]* {
                 adjust();
                 char *yptr = yytext;
                 while (*yptr) {
                   update_buffer(*yptr++);
                 }
               }

}


<COMMENT>{

    "/*" {
           adjust();
           comment_depth++;
           continue;
         }

    /* When a comments closes we decrease the depth. A depth of zero makes us
       switch out of the COMMENT state */
    "*/" {
           adjust();
           comment_depth--;
           if (comment_depth == 0) {
             BEGIN(INITIAL);
           }
         }

    /* Reaching EOF inside a comment */
    <<EOF>> {
              EM_error(EM_token_pos, "EOF reached without finishing comment");
              yyterminate();
            }

    /* Ignore everything else inside a comment */
    . {
        adjust();
      }

}


%%

int yywrap() {
    char_pos = 1;
    return 1;
}

void adjust() {
    EM_token_pos = char_pos;
    char_pos += yyleng;
}

void init_buffer(void)
{
  buffer = malloc_checked(INITIAL_LENGTH);
  buffer[0] = 0;
  capacity = INITIAL_LENGTH;
}

/* Add chararacter to buffer and double the length if capacity is reached */
 
void update_buffer(char ch)
{
    size_t new_length = strlen(buffer) + 1;
    if (new_length == capacity)
    {
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

