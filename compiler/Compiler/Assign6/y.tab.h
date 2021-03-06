/* A Bison parser, made by GNU Bison 2.5.  */

/* Bison interface for Yacc-like parsers in C
   
      Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
   
   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.
   
   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.
   
   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     SPACE = 258,
     DATATYPE = 259,
     SEMICOLON = 260,
     COMMA = 261,
     IDENTIFIER = 262,
     NUMBER = 263,
     PLUS = 264,
     SUB = 265,
     MUL = 266,
     DIV = 267,
     MOD = 268,
     ASSIGNMENT = 269,
     LEFTBRAC = 270,
     LEFTSECBRAC = 271,
     RIGHTBRAC = 272,
     RIGHTSECBRAC = 273,
     IF = 274,
     ELSE = 275,
     WHILE = 276,
     GREATER = 277,
     GREATER_EQUAL = 278,
     LESSER = 279,
     LESSER_EQUAL = 280,
     EQUALITY = 281,
     UMINUS = 282
   };
#endif
/* Tokens.  */
#define SPACE 258
#define DATATYPE 259
#define SEMICOLON 260
#define COMMA 261
#define IDENTIFIER 262
#define NUMBER 263
#define PLUS 264
#define SUB 265
#define MUL 266
#define DIV 267
#define MOD 268
#define ASSIGNMENT 269
#define LEFTBRAC 270
#define LEFTSECBRAC 271
#define RIGHTBRAC 272
#define RIGHTSECBRAC 273
#define IF 274
#define ELSE 275
#define WHILE 276
#define GREATER 277
#define GREATER_EQUAL 278
#define LESSER 279
#define LESSER_EQUAL 280
#define EQUALITY 281
#define UMINUS 282




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
{

/* Line 2068 of yacc.c  */
#line 38 "LexIntermediate.y"
char *str;int num;


/* Line 2068 of yacc.c  */
#line 108 "y.tab.h"
} YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


