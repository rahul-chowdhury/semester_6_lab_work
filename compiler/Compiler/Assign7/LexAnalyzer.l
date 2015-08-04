%{
	#include "y.tab.h"
	#include<stdlib.h>

	int insert(char *,char *,int);
	int search(char *,int);
	char *types[]={"int","float","char"};
	int new=0;int new_type=0;
	int i,vtoken,ntoken;
	int SIZE=70;
%}


%%
"\n"			{
				yylineno++;
			}
"if"			{return IF;}
"else"			{return ELSE;}
"int"			{
				new=1;
				new_type=0;
				return INT;
			}


"float"			{
				new=1;
				new_type=1;
				return FLOAT;
			}

"char"			{
				new=1;
				new_type=2;
				return CHAR;
			}


"for"			{return FOR;}
"while"			{return WHILE;}
"break"			{return BREAK;}
"struct"		{return STRUCT;}
"+"			{return PLUS;}
"-"			{return MINUS;}
"/"			{return DIV;}
"*"			{return MUL;}
"--"			{return DEC;}
"++"			{return INC;}
"=="			{return EQ;}
"="			{return ASSIGN;}
"!="			{return NEQ;}
">"			{return GT;}
"<"			{return LT;}
">="			{return GE;}
"<="			{return LE;}
"&&"			{return AND;}
"||"			{return OR;}
"~"			{return NOT;}
"&"			{return AMPS;}
"("			{return OPENPAR;}
")"			{return CLOSEPAR;}
";"			{
				new=0;						
				return SEMICOL;
			}

"{"			{return OPENBRC;}
"}"			{return CLOSEBRC;}


","			{return COMMA;}

[_a-zA-Z][_a-zA-Z0-9]*	{
			if(new==1)
				if(search(yytext,SIZE)==-1){
					insert(yytext,types[new_type],SIZE);
					return IDENTIFIER;
				}
				else{
					printf("Line No %d : Type Redefination of \"%s\"\n",yylineno,yytext);
					exit(0);
				}
			else
				if(search(yytext,SIZE)==-1){
					printf("Line No %d : Undefined keyword \"%s\"\n",yylineno,yytext);
					exit(0);
				}
				else
					return IDENTIFIER;
			}

[1-9][0-9]*		{
			return NUMBER;
			}

.			{;}
%%


char **I;
char **T;
FILE *fp;

extern void *malloc();
extern FILE *yyin;

int main(){
	int i,j;
	I=(char **)malloc(SIZE*sizeof(char *));
	for(i=0;i<SIZE;i++)
		I[i]=(char *)malloc(20*sizeof(char));

	T=(char **)malloc(SIZE*sizeof(char *));
	for(i=0;i<SIZE;i++)
		T[i]=(char *)malloc(10*sizeof(char));


	fp=fopen("icode.txt","w");
	
	yyparse();

	fclose(fp);
	return 0;	
}

yyerror(s)
char *s;
{
	fprintf(stderr, "%s\n", s);
}

int insert(char *name,char *type,int size){
      int count = 0,key=0,i;
      for(i=0;i<SIZE;i++)
	    if(I[i][0]!='\0')
		  count++;
      if((float) (count / SIZE) > 0.7)
  printf("Rehash");

     
      for(i=0;name[i]!='\0';i++)
	    key=key+name[i];
      

      int addr=key%size;
      int offset=key/size;
      
      while(I[addr][0]!='\0')
	    addr=(addr+offset)%size;
      strcpy(I[addr],name);
      strcpy(T[addr],type);
      return addr;
}

int search(char *name,int size){
  
      int key=0,i;
      
      for(i=0;i<size;i++)
	    if(strcmp(I[i],name)==0)
		  return i;
      return -1;
}
