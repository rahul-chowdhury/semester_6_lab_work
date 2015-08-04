%{
	#include<string.h>
	#include<stdlib.h>
%}
ID	[a-zA-Z_][a-zA-Z0-9_]*
%%
" "+		{/*White Space*/}
"if"		{printf("IF\n");}
"else"		{printf("ELSE\n");}
"int"		{printf("INT\n");}
"float"		{printf("FLOAT\n");}
"char"		{printf("CHAR\n");}
"for"		{printf("FOR\n");}
"while"		{printf("WHILE\n");}
"break"		{printf("BREAK\n");}
"struct"	{printf("STRUCT\n");}
"+"		{printf("PLUS\n");}
"-"		{printf("MINUS\n");}
"/"		{printf("DIV\n");}
"*"{ID}		{printf("PTR\n"); install_id(&yytext[1]);}
{ID}"*"{ID}	{install_id(strextract(yytext,'*'); printf("MUL\n"); install_id(strextract(&yytext[strstr(yytext,"*")+1]),'\0');}
"%"		{printf("MOD\n");}
"--"		{printf("DEC\n");}
"++"		{printf("INC\n");}
"="		{printf("ASSIGN\n");}
"=="		{printf("EQ\n");}
"!="		{printf("NEQ\n");}
">"		{printf("GT\n");}
"<"		{printf("LT\n");}
">="		{printf("GE\n");}
"<="		{printf("LE\n");}
"&&"		{printf("AND\n");}
"||"		{printf("OR\n");}
"~"		{printf("NOT\n");}
"&"		{printf("AMPS\n");}
";"		{printf("SEMICOL\n");}
","		{printf("COMMA\n");}
[0-9]+		{printf("Number\n");}
{ID}		{install_id(yytext);}
.		{printf("Unexpexted Character\n");}
%%
int main()
{
	yylex();
	return 0;
}
char *strextract(char *s,char ch)
{
	char *str=(char *)malloc(sizeof(char)*MAXSIZE);
	for(i=0;i<MAXSIZE && s[i]!==ch;i++)
		str[i]=s[i];
	str[i]='\0';
	return str;
}
int install_id(char *s)
{
	printf("Identifier=%s\n",s);
}
