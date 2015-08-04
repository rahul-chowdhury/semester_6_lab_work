%{
	#include<stdio.h>
	#include<ctype.h>
	#include<string.h>
	#define MAXSIZE 10
	typedef struct Table
	{
		char symbol[10];
		char type[10];
		int value;
		int initialise;
		struct Table *next;
	}SymbolTable;
	extern SymbolTable symTable[MAXSIZE];
	extern int search(SymbolTable symTable[],char symbol[]);
	extern void update(SymbolTable symTable[],char symbol[],int value);
	extern int getValue(SymbolTable symTable[],char symbol[]);
	extern void display(SymbolTable symTable[]);
	extern int count,mylineno;
	void yyerror(char *s);
	void push(char *text);
	
	char st[100][100];
	int top=0,ind=0;
	char i_[10]="0";
	char temp[2]="t";
%}

%union {char *str;int num;}
%start statements
%token SPACE 
%token DATATYPE 
%token SEMICOLON 
%token COMMA
%token <str> IDENTIFIER
%token <str> NUMBER
%token <str> PLUS
%token <str> SUB
%token <str> MUL
%token <str> DIV
%token <str> MOD
%token <str> ASSIGNMENT
%token LEFTBRAC
%token RIGHTBRAC

%right ASSIGNMENT
%left PLUS SUB
%left MUL DIV 
%left UMINUS
%%

statements	: declaration					{;}
		| declaration statements			{;}
		| expressions					{;}
		;
		
declaration 	: DATATYPE SPACE IDENTIFIER SEMICOLON		{printf("IDENTIFIER %s has been declared properly\n",$3);}
		| DATATYPE SPACE IDENTIFIER terms SEMICOLON	{printf("IDENTIFIER %s has been declared properly\n",$3);}
		;		

terms		: term terms					{;}
		| term						{;}
		;

term		: COMMA IDENTIFIER				{printf("IDENTIFIER %s has been declared properly\n",$2);}
		| COMMA SPACE IDENTIFIER			{printf("IDENTIFIER %s has been declared properly\n",$3);}
		; 

expressions	: expression expressions 			{;}
		| expression					{;}
		;
		
expression	: IDENTIFIER{push($1);} ASSIGNMENT {push($1);} Expression {codegen_assign();} SEMICOLON
   		;
Expression	: Expression PLUS {push($2);} T {codegen();}
   		| Expression SUB {push($2);} T {codegen();}
   		| T
   		;
T 		: T MUL {push($2);} F {codegen();}
   		| T DIV {push($2);} F {codegen();}
   		| F
   		;
F 		: LEFTBRAC Expression RIGHTBRAC
   		| SUB {push($1);} F {codegen_umin();} %prec UMINUS
   		| IDENTIFIER {push($1);}
   		| NUMBER {push($1);}
   		;
%%

void push(char *text)
{
	strcpy(st[++top],text);
	//printf("%s\n",text);
}

codegen()
{
	 strcpy(temp,"t");
	 strcat(temp,i_);
	 printf("%s = %s %s %s\n",temp,st[top-2],st[top-1],st[top]);
	 top-=2;
	 strcpy(st[top],temp);
	 ind++;
	 sprintf(i_,"%d",ind);
}

codegen_umin()
{
	 strcpy(temp,"t");
	 strcat(temp,i_);
	 printf("%s = -%s\n",temp,st[top]);
	 top--;
	 strcpy(st[top],temp);
	 ind++;
	 sprintf(i_,"%d",ind);
}
	
codegen_assign()
{
	 printf("%s = %s\n",st[top-2],st[top]);
	 top-=2;
}

void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
}
