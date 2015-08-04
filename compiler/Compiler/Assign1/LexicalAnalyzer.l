%{
	#define IDENT 5
%}

%%
"{ws}"		printf("{ } ");
"if" 		printf("IF ");
"else" 		printf("ELSE ");
"int" 		return 1;
"float" 	return 2;
"char" 		return 3;
"for" 		printf ("FOR ");
"while" 	printf("WHILE ");
"break" 	printf("BREAK ");
"struct" 	printf("STRUCT ");
"+" 		printf("PLUS ");
"-" 		printf("SUB ");
"/" 		printf("DIV ");
"*" 		printf("MUL ");
"%" 		printf("MOD ");
"--" 		printf("DEC ");
"++" 		printf("INC ");
"=" 		printf("ASSIGNMENT ");
"==" 		printf("EQ ");
"!=" 		printf("NEQ ");
">" 		printf("GT ");
"<" 		printf("LT ");
">=" 		printf("GE ");
"<=" 		printf("LE ");
"&&" 		printf("AND ");
"||" 		printf("OR ");
"~" 		printf("NOT ");
"&" 		printf("AMPS ");
";" 		printf("SEMICOL ");
"," 		printf("COMMA ");
[0-9]+ 		printf("NUM ");
[a-zA-Z]+ 	return IDENT; 
"^" 		return 0;
%%
int yywrap(void)
{
	return 1;
}
