#include <stdio.h>
#include<stdlib.h>
#include<string.h>
#define IDENT 5

extern int yylex();
extern int yylineno;
extern char* yytext;

struct ident
{
	char s[10];
	int n;
	char ty[10];
	struct ident*  ptr;
};

void build_table(char c[10],int mod_val,struct ident** arr,char* t)
{
	
	int i=1;
	if((*arr)==NULL)
	{
		(*arr)=(struct ident*)malloc(sizeof(struct ident));
		while(c[i-1]!='\0')
		{
			(*arr)->s[i-1]=c[i-1];
			i++;
		}
		(*arr)->s[i-1]='\0';
		//printf("%s\n",(*arr)->s);
		//(*arr)->s=c;
		(*arr)->n=mod_val;
		i=1;
		if(t==NULL)
		(*arr)->ty[0]='\0';
		else
		{
			while(t[i-1]!='\0')
			{
				(*arr)->ty[i-1]=t[i-1];
				i++;
			}
		}
		(*arr)->ty[i-1]='\0';
		(*arr)->ptr=NULL;
		return;
	}
	
	if(strcmp((*arr)->s,c)!=0)
	build_table(c,mod_val,&((*arr)->ptr),t);
	else
	return;
	
	return;
}
	
	
void display(struct ident** arr)
{
	if(*arr==NULL)
	return;
	else
	{
		printf("|%d|-> ",(*arr)->n);
		printf("%s-",(*arr)->s);
		printf("%s ",(*arr)->ty);
		display(&((*arr)->ptr));
	}
	return;
}

int main(void)
{
	int token,k,i,val,token1;
	char c;
	char s[10];
	struct ident* id[7];
	for(i=1;i<=7;i++)
	id[i-1]=NULL;
	token=yylex();
	while(token)
	{
		if(token==5)
		{
		//store();
		 	printf("%s ","IDENTIFIER");	
		 	c=yytext[0];
		 	c='\0';
		 	for(k=0;k<strlen(yytext);k++)
		 	c=c+yytext[k];
		 	build_table(yytext,(int)c%7,&id[(int)c%7],NULL);
		}
		if(token==1 || token==2 || token==3)
		{
			i=1;
			while(yytext[i-1]!='\0')
			{
				s[i-1]=yytext[i-1];
				i++;
			}
			s[i-1]='\0';
			printf("%s ",yytext);
			token1=yylex();
			printf("%s ","IDENTIFIER");	
		 	c=yytext[0];
		 	c='\0';
		 	for(k=0;k<strlen(yytext);k++)
		 	c=c+yytext[k];
		 	build_table(yytext,(int)c%7,&id[(int)c%7],s);
		}
		if(token==0)
		break;	
		//printf("%s",yytext);
		token=yylex();
	}
	for(i=1;i<=7;i++)
	{
		display(&id[i-1]);
		printf("\n");
	}
	return 0;
}
