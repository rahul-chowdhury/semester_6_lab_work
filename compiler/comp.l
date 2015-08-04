
%{
	#include<string.h>
	int getid(char text[100]);
%}

delim [ \n\t]
ws [delim]+
letter [a-zA-Z]
%%
int 		printf("keyword: INTEGER\n");
float 		printf("keyword: FLOAT\n");
auto 		printf("keyword: AUTO\n");
break 		printf("keyword: BREAK\n");
case 		printf("keyword: CASE\n");
char 		printf("keyword: CHAR\n");
const 		printf("keyword: CONST\n");
continue 	printf("keyword: CONTINUE\n");
default 	printf("keyword: DEFAULT\n");
do 		printf("keyword: DO\n");
double 		printf("keyword: DOUBLE\n");
else 		printf("keyword: ELSE\n");
enum 		printf("keyword: ENUM\n");
extern 		printf("keyword: EXTERN\n");
for 		printf("keyword: FOR\n");
goto 		printf("keyword: GOTO\n");
if 		printf("keyword: IF\n");
long 		printf("keyword: LONG\n");
register 	printf("keyword: REGISTER\n");
return		printf("keyword: RETURN\n");
short 		printf("keyword: SHORT\n");
signed 		printf("keyword: SIGNED\n");
sizeof 		printf("keyword: SIZEOF\n");
static 		printf("keyword: STATIC\n");
struct 		printf("keyword: STRUCT\n");
switch 		printf("keyword: SWITCH\n");
typedef 	printf("keyword: TYPEDEF\n");
union 		printf("keyword: UNION\n");
unsigned 	printf("keyword: UNSIGNED\n");
void 		printf("keyword: VOID\n");
volatile 	printf("keyword: VOLATILE\n");
"=" 		printf("equals\n");
"quit"		return;
[a-zA-Z][a-zA-Z0-9_]* 		printf("id[%d]\n",getid(yytext));
[ \n\t]+ 	printf("whitespace\n");
[0-9]+ 		printf("number\n");

%%


int count;
struct var_details
{
	int index;
	char var_name[100];
};
struct var_details hash[100];
main()
{
	int i;
	for(i=0;i<100;i++)
	strcpy(hash[i].var_name,"");
	count=0;
        yylex();
        print_symbtable();
	
}

int getid(char text[])
{
	char temp[100];
	strcpy(temp,text);
	int sum=0,len=strlen(temp)-1;
	while(len>=0)
	{
		sum +=temp[len--];
	}
	sum %= 100;
	if(strcpy(hash[sum].var_name,"")==0)
	{
		strcpy(hash[sum].var_name,text);
		hash[sum].index=++count;
		return count;
	}
	else
	{
		while(sum<100 && strcmp(hash[++sum].var_name,"")!=0)
		{}
		if(sum==100)
		{
			return -1;
		}
		strcpy(hash[sum].var_name,text);
		hash[sum].index=++count;
		return count;
	}
}
	
void print_symbtable()
{
	int i;
	for(i=0;i<100;i++)
	{
		if(strcmp(	
			
	
		
	
	
yywrap(){}

