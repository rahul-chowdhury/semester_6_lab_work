%{ 
	#include<stdio.h>
	#include<string.h>
	#include<ctype.h>
%}

%token WHITESPACE IF ELSE INT FLOAT CHAR FOR WHILE BREAK STRUCT PLUS MINUS DIV MUL MOD DEC INC ASSIGN EQ NEQ GT LT GE LE AND OR NOT AMPS OPENPAR CLOSEPAR SEMICOL COMMA IDENTIFIER UNDEFINED NUMBER OPENBRC CLOSEBRC
%%

main :		declare assignment
	|	declare assignment ifelse while
	|	declare assignment while ifelse
	|	declare assignment ifelse assignment
	|	declare ifelse assignment
	|	declare assignment ifelse
	|	declare assignment while assignment
	|	declare while assignment
	|	declare assignment while
	;
		
declare :	declare declare
	|	type identifier_list SEMICOL	
	;

assignment:	assignment assignment
	|	IDENTIFIER{push();} ASSIGN{push();} E{codegen_assign();} SEMICOL
	;	

ifelse	:	IF OPENPAR comparision{codegen_comparision();} CLOSEPAR OPENBRC assignment{bodypart();} CLOSEBRC ELSE OPENBRC assignment{outerpart();} CLOSEBRC
	;

while	:	WHILE OPENPAR{while_label();} comparision{codegen_comparision();} CLOSEPAR OPENBRC assignment{while_bodypart();} CLOSEBRC
	;

comparision:	E relop{push();} E
	; 


E:		E PLUS{push();} F{codegen();}
	|	E MINUS{push();} F{codegen();}
	|	F
	;

F:		F MUL{push();} G{codegen();}
	|	F DIV{push();} G{codegen();}
	|	G
	;


G:		IDENTIFIER  {push();}
	|	NUMBER	    {push();}
	;

relop:		EQ
	|	NEQ
	|	GT
	|	LT
	|	GE
	|	LE
	;		

identifier_list:	IDENTIFIER
	|	identifier_list COMMA IDENTIFIER
	;

type	: 	INT
	| 	FLOAT
	| 	CHAR
	;

%%


extern char *yytext;
char stack[200][10];
char temp[2];
int top=0;
char ext[2]="0";
int t=0;

int label[20];
int lnum=0;
int ltop=0;
int divL=1;
int mulL=1;
extern FILE *fp;


push(){
	strcpy(stack[++top],yytext);
}

codegen(){
	int i,j;
	strcpy(temp,"t");
 	strcat(temp,ext);
  	fprintf(fp,"\t%s = %s %s %s\n",temp,stack[top-2],stack[top-1],stack[top]);

	top-=2;	

 	strcpy(stack[top],temp);
	nextTemp();
}

codegen_assign(){
	fprintf(fp,"\t%s = %s\n",stack[top-2],stack[top]);		
	top-=2;
}

bodypart(){
	int x;
	lnum++;
	x=label[ltop--];
	fprintf(fp,"\tGOTO L%d\n",lnum);
	fprintf(fp,"L%d: ",x);
	label[++ltop]=lnum;
}

while_bodypart(){
	int x;
	lnum++;
	x=label[ltop--];
	fprintf(fp,"\tGOTO L%d\n",x-1);
	fprintf(fp,"L%d: ",x);
	label[++ltop]=lnum;
}

outerpart(){
	int y;
	y=label[ltop--];
	fprintf(fp,"L%d:",y);
}

codegen_comparision(){
	lnum++;
	strcpy(temp,"t");
	strcat(temp,ext);
	nextTemp();
	fprintf(fp,"\t%s = %s %s %s\n",temp,stack[top-2],stack[top-1],stack[top]);
	top-=2;
 	strcpy(stack[top],temp);
	strcpy(temp,"t");
	strcat(temp,ext);
	fprintf(fp,"\t%s = NOT %s\n",temp,stack[top]);
	fprintf(fp,"\tif %s GOTO L%d\n",temp,lnum);
	nextTemp();
	label[++ltop]=lnum;
}

while_label(){
	fprintf(fp,"L%d:",lnum);
}

nextTemp(){
	t++;
	if(t>=10){
		ext[1]=t%10 + '0';	
		ext[0]=t/10 + '0';
	}
	else
		ext[0]++;
}
