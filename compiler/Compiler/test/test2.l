%{
int charcount=0,linecount=0,wordcount=0,letter=0;
%}
letter [ˆ\t\n]
%%
{letter}+ {wordcount++; charcount+=yyleng; letter+=yyleng;}
\n {charcount++;linecount++;}
. charcount++;
%%
int main()
{
	yylex();
	printf("Letter=%d Word=%d Characters=%d Line=%d\n",letter,wordcount,charcount,linecount);
	return 0;
}
