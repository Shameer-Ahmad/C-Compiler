%{
#include <string.h>

#include "errormsg.h"
#include "tokens.h"
#include "util.h"

int char_pos = 1;

void adjust();
%}

%option nounput noinput

space [ \t]
ws {space}+
digit [0-9]
lower   [a-z]
upper   [A-Z]
letter  ({lower}|{upper})   // Any alphabetic character
alnum   ({letter}|{digit})  // Any letter or digit

%%

{ws}        { adjust(); continue; }
\n	        { adjust(); EM_newline(); continue; }
","	        { adjust(); return COMMA; }
for  	    { adjust(); return FOR; }
{digit}+	{ adjust(); yylval.ival = atoi(yytext); return INT; }
.	        { adjust(); EM_error(EM_token_pos, "illegal token"); }


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
{_letter}+[_{alnum}]* {
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


%%

int yywrap() {
    char_pos = 1;
    return 1;
}

void adjust() {
    EM_token_pos = char_pos;
    char_pos += yyleng;
}

