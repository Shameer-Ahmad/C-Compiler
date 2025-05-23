/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_TIGER_TAB_H_INCLUDED
# define YY_YY_TIGER_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    ID = 258,                      /* ID  */
    INT = 259,                     /* INT  */
    PLUS = 260,                    /* PLUS  */
    MINUS = 261,                   /* MINUS  */
    TIMES = 262,                   /* TIMES  */
    DIVIDE = 263,                  /* DIVIDE  */
    EQ = 264,                      /* EQ  */
    NEQ = 265,                     /* NEQ  */
    LT = 266,                      /* LT  */
    LE = 267,                      /* LE  */
    GT = 268,                      /* GT  */
    GE = 269,                      /* GE  */
    ASSIGN = 270,                  /* ASSIGN  */
    ARRAY = 271,                   /* ARRAY  */
    IF = 272,                      /* IF  */
    THEN = 273,                    /* THEN  */
    ELSE = 274,                    /* ELSE  */
    WHILE = 275,                   /* WHILE  */
    FOR = 276,                     /* FOR  */
    TO = 277,                      /* TO  */
    DO = 278,                      /* DO  */
    LET = 279,                     /* LET  */
    IN = 280,                      /* IN  */
    END = 281,                     /* END  */
    OF = 282,                      /* OF  */
    BREAK = 283,                   /* BREAK  */
    NIL = 284,                     /* NIL  */
    FUNCTION = 285,                /* FUNCTION  */
    VAR = 286,                     /* VAR  */
    TYPE = 287,                    /* TYPE  */
    LPAREN = 288,                  /* LPAREN  */
    RPAREN = 289,                  /* RPAREN  */
    COMMA = 290,                   /* COMMA  */
    COLON = 291,                   /* COLON  */
    SEMICOLON = 292,               /* SEMICOLON  */
    LBRACE = 293,                  /* LBRACE  */
    RBRACE = 294,                  /* RBRACE  */
    LOW_PRECEDENCE = 295,          /* LOW_PRECEDENCE  */
    LOWER_THAN_ELSE = 296          /* LOWER_THAN_ELSE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 14 "tiger.grm"

    int ival;
    char *sval;
    A_Exp exp;
    A_Var var;
    A_Dec dec;
    A_Type type;
    A_ExpList explist;
    A_DecList declist;
    A_EField efield;
    A_EFieldList efieldlist;
    A_Field field;
    A_FieldList fieldlist;
    A_FunDec fundec;
    A_FunDecList fundeclist;

#line 122 "tiger.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif

/* Location type.  */
typedef E_Pos YYLTYPE;




int yyparse (void);


#endif /* !YY_YY_TIGER_TAB_H_INCLUDED  */
