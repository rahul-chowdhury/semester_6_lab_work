%{
	#include<stdio.h>
	#include<string.h>
	#include "header.h"
	#define MAXSIZE 10
	typedef struct Table
	{
		char symbol[10];
		struct Table *next;
	}SymbolTable;
	SymbolTable symTable[MAXSIZE];
	int declare=0;
	int mylineno=1,count=0,myerror=0;
%}

%%
" "		{return SPACE;}
"\t"		{return SPACE;}
"int"		{
			declare=1;
			return DATATYPE;
		}
"float"		{
			declare=1;
			return DATATYPE;
		}
"char"		{
			declare=1;
			return DATATYPE;	
		}
";"		{
			declare=0;
			return SEMICOLON;
		}
","		{return COMMA;}
"\n"		{
			mylineno++;
		}

[a-zA-Z_0-9]+	{
			return IDENTIFIER;
		}
.		{
			declare=0;
			count++;
			myerror=1;
			printf("ERROR %d: Unexpected character in line no. %d\n",count,mylineno);
		}
%%
int search(SymbolTable symTable[],char symbol[])
{
	int i,key=0;
	for(i=0;i<strlen(symbol);i++)
	key=key+symbol[i];
	SymbolTable *move;
	move=&(symTable[key%MAXSIZE]);
		
	while(move!=NULL)
	{
		if(strcmp(move->symbol,symbol)==0)
		return 1;
		move=move->next;
	}
	return 0;
}

int insert(SymbolTable symTable[],char symbol[])
{
	int i,key=0;
	for(i=0;i<strlen(symbol);i++)
	key=key+symbol[i];
	SymbolTable *newnode,*move;
	
	if(symTable[key%MAXSIZE].symbol[0]=='\0')
	{
		strcpy(symTable[key%MAXSIZE].symbol,symbol);
		symTable[key%MAXSIZE].next=NULL;
	}
	else
	{
		if(search(symTable,symbol)==0)
		{
			move=&(symTable[key%MAXSIZE]);
			while(move->next!=NULL)
			move=move->next;
			
			newnode=(SymbolTable *)malloc(sizeof(SymbolTable));
			strcpy(newnode->symbol,symbol);
			newnode->next=NULL;
			move->next=newnode;
		}
		else
		return 0;
	}
	return 1;
}

void display(SymbolTable symTable[])
{
	int i;
	SymbolTable *move;
	printf("SYMBOL TABLE:\n");
	for(i=0;i<MAXSIZE;i++)
	{
		move=&(symTable[i]);
		printf("|%d|",i);
		while(move!=NULL)
		{
			printf(" %s --> ",move->symbol);
			move=move->next;
		}
		printf("NULL\n");
	}
}

int main(void)
{
	int i,ntoken;
	for(i=0;i<MAXSIZE;i++)
	{
		symTable[i].symbol[0]='\0';
		symTable[i].next=NULL;
	}
	ntoken=yylex();
	while(ntoken)
	{
		if(ntoken==IDENTIFIER)
		{
			if(declare==1)
			{
				if(insert(symTable,yytext)==0)
				{
					count++;
					printf("Error %d: IDENTIFIER %s in line no. %d has been declared earlier\n",count,yytext,mylineno);
				}
			}
			else
			{
				if(search(symTable,yytext)==0)
				{
					if(myerror==0)
					{
						count++;
						printf("Error %d: IDENTIFIER %s in line no. %d is not declared\n",count,yytext,mylineno);
					}
					else
					{
						myerror=0;
						count++;
						printf("ERROR %d: IDENTIFIER %s in line no. %d cannot be declared\n",count,yytext,mylineno);
					}
				}
			}
		}
		ntoken=yylex();
	}
	display(symTable);
	return 0;
}

int yywrap(void)
{
	return 1;
}
