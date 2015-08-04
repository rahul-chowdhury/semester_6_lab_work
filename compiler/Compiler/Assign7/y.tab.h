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
     WHITESPACE = 258,
     IF = 259,
     ELSE = 260,
     INT = 261,
     FLOAT = 262,
     CHAR = 263,
     FOR = 264,
     WHILE = 265,
     BREAK = 266,
     STRUCT = 267,
     PLUS = 268,
     MINUS = 269,
     DIV = 270,
     MUL = 271,
     MOD = 272,
     DEC = 273,
     INC = 274,
     ASSIGN = 275,
     EQ = 276,
     NEQ = 277,
     GT = 278,
     LT = 279,
     GE = 280,
     LE = 281,
     AND = 282,
     OR = 283,
     NOT = 284,
     AMPS = 285,
     OPENPAR = 286,
     CLOSEPAR = 287,
     SEMICOL = 288,
     COMMA = 289,
     IDENTIFIER = 290,
     UNDEFINED = 291,
     NUMBER = 292,
     OPENBRC = 293,
     CLOSEBRC = 294
   };
#endif
/* Tokens.  */
#define WHITESPACE 258
#define IF 259
#define ELSE 260
#define INT 261
#define FLOAT 262
#define CHAR 263
#define FOR 264
#define WHILE 265
#define BREAK 266
#define STRUCT 267
#define PLUS 268
#define MINUS 269
#define DIV 270
#define MUL 271
#define MOD 272
#define DEC 273
#define INC 274
#define ASSIGN 275
#define EQ 276
#define NEQ 277
#define GT 278
#define LT 279
#define GE 280
#define LE 281
#define AND 282
#define OR 283
#define NOT 284
#define AMPS 285
#define OPENPAR 286
#define CLOSEPAR 287
#define SEMICOL 288
#define COMMA 289
#define IDENTIFIER 290
#define UNDEFINED 291
#define NUMBER 292
#define OPENBRC 293
#define CLOSEBRC 294




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;


