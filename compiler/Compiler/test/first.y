%{
	#include<stdio.h>
	void yyerror(char *s);
%}

%token NAME NUMBER

%%
statement: 	NAME '=' expression
		| expression		{ printf("= %d\n", $1); }
		;

expression: 	expression '+' NUMBER 	{ $$ = $1 + $3; }
		| expression '-' NUMBER { $$ = $1 - $3; }
		| NUMBER 		{ $$ = $1; }
		;
%%

int main(void)
{
	return yyparse();
}

void yyerror(char *s)
{
	fprintf(stderr,"%s\n",s);
}
