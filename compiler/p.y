%{
	#include<stdio.h>
	#include<string.h>
	#define TABLE_SIZE 20
	#define ID_SIZE 20
	#define SYMBOL_TABLE_OVERFLOW -1
	#define UNDECLARED -2
	#define REDECLARATION -3
	#define DECLARATION 0
	#define USAGE 1
	int type_flag;
	int temp;
	char str[20];
	char *newTemp();
	int build_operand(int);
	
	typedef struct{
		char code[1000];
		char place[20];
		int operand_index;	//index in the operand descriptor table
	}value;
	
	typedef struct{
		char mode;	// 'S' or 'R'
		int address;	//The index field in symbol table is considered as the address when mode is 'S'
	}operand;	
	operand operand_descriptor[10];
	
	char *codegen(char[],value,value,int*);
	void free_reg();
	
	 
%}

%union{
	char id_name[20];
	value temp;
}

%token IF ELSE WHILE FOR BREAK CONTINUE RETURN CASE CHAR CONST DEFAULT DO DOUBLE FLOAT INT LONG SHORT
%token <id_name> IDENTIFIER NUMBER

  
%start program
%type<temp> exp assignment
%left '+' '-' 
%left '*' '/'

%%

program: statement
		|
		program statement
;

statement: declaration
		|
		assignment
;

declaration: declaration_specifiers ';'
;

declaration_specifiers: datatype idlist
;

datatype: INT	{type_flag=INT;}
		|
		FLOAT	{type_flag=FLOAT;}
		|
		CHAR	{type_flag=CHAR;}
;

idlist: idlist ',' IDENTIFIER  
		{
		 	if(checkHash($3,type_flag,DECLARATION)==REDECLARATION){
		 		printf("Error: Redeclaration of variable %s\n",$3);
		 		return 0;
		 	} 
		}
		|
		IDENTIFIER 
		{ 
			if(checkHash($1,type_flag,DECLARATION)==REDECLARATION){
				printf("Error: Redeclaration of variable %s\n",$1);
				return 0;
			}
		}
;

assignment:	IDENTIFIER '=' exp ';'
{
	strcpy($$.code, $3.code);
	if(operand_descriptor[$3.operand_index].mode=='R')	sprintf(str, "STORE %d,%s", operand_descriptor[$3.operand_index].address, $1);
	else{
		temp=build_operand(-1);
		sprintf(str, "LOAD %d,%s\nSTORE %d,%s", temp, $3.place, temp, $1);
	}
	strcat($$.code,str);
	strcat($$.code, "\n");
	
	printf("\n%s\n",$$.code);
	
	free_reg();
}
;

exp: IDENTIFIER	
	{
		if( (temp=checkHash($1, NULL, USAGE))==UNDECLARED ){
			printf("Error: Undeclared identifier %s\n",$1);
			return 0;
		}
		else{ 
			strcpy($$.place,$1);
			strcpy($$.code,"");
			$$.operand_index=build_operand(temp);
		}
	}
	|
	NUMBER
	{
		strcpy($$.place,$1);
		strcpy($$.code,"");
	}
;

exp: exp '+' exp 
{
	strcpy($$.place,newTemp()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code, codegen("ADD",$1,$3,&($$.operand_index)) );
	strcat($$.code, "\n");
} 
;

exp: exp '-' exp
{
	strcpy($$.place,newTemp()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code, codegen("SUB",$1,$3,&($$.operand_index)));
	strcat($$.code, "\n");
}
;

exp: exp '*' exp
{
	strcpy($$.place,newTemp()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code, codegen("MULT",$1,$3,&($$.operand_index)));
	strcat($$.code, "\n");
}
;

exp: exp '/' exp
{
	strcpy($$.place,newTemp()); 
	strcpy($$.code,$1.code);
	strcat($$.code,$3.code);
	strcat($$.code, codegen("DIV",$1,$3,&($$.operand_index)));
	strcat($$.code, "\n");
}
;

exp: '(' exp ')'
{
	strcpy($$.place,$2.place); 
	strcpy($$.code,$2.code);
	$$.operand_index=$2.operand_index;
}
;


%%

int id_count=0;
int reg_top=0;

typedef struct{
	char s[ID_SIZE];
	char type[10];
	int index;			//This field is used as the address of the operand when the mode is 'S' 
	
}symbol;
symbol *symbolTable[TABLE_SIZE];


typedef struct{
	int used;	// 0 or 1
	int operand_index;	//index to the operand descriptor table
}reg;
reg reg_descriptor[10];



int main(){

	int i;
	
	// Initialization
	for(i=0; i<TABLE_SIZE; i++)	symbolTable[i]=NULL;
	
	for(i=0; i<10; i++)	reg_descriptor[i].used=0;
	
	
	yyparse();
	
	/*printf("..............Displaying the symbol table...................\n");
	for(i=0; i<TABLE_SIZE; i++){
		if(symbolTable[i]==NULL)	printf("%d: <empty>\n",i);
		else printf("%d: %s  ID%d  type:%s\n", i,symbolTable[i]->s,symbolTable[i]->index,symbolTable[i]->type);
	}
	printf("\n");
	*/
	return 0;
}


int build_operand(int address){	//address=-1 if 'R' mode,  address=symbol table index if 'S' mode
	static int i=-1;
	i++;
	if(address>=0){
		operand_descriptor[i].mode='S';
		operand_descriptor[i].address=address;
	}
	else{
		reg_top++;
		operand_descriptor[i].mode='R';
		operand_descriptor[i].address=reg_top;
		reg_descriptor[reg_top].used=1;
		reg_descriptor[reg_top].operand_index=i;
	}
	
	return i;
}

char *codegen(char opcode[], value opnd1, value opnd2, int *setOperandIndex){

	char *code;
	char op1_mode,op2_mode;
	int op1_addr,op2_addr;
	int temp;
	
	code=(char*)malloc(20);
	
	op1_mode=operand_descriptor[opnd1.operand_index].mode;
	op2_mode=operand_descriptor[opnd2.operand_index].mode;
	op1_addr=operand_descriptor[opnd1.operand_index].address;
	op2_addr=operand_descriptor[opnd2.operand_index].address;
	
	if(op1_mode=='R'){
	
		if(op2_mode=='R')	sprintf(code,"%s %d,%d",opcode,op1_addr,op2_addr);
		else	sprintf(code,"%s %d,%s",opcode,op1_addr,opnd2.place);
		
		*setOperandIndex=opnd1.operand_index;
	}
	else if(op2_mode=='R'){
	
		sprintf(code,"%s %d,%s",opcode,op2_addr,opnd1.place);
		*setOperandIndex=opnd2.operand_index;

	}
	else{
		*setOperandIndex=build_operand(-1);
		temp=operand_descriptor[(*setOperandIndex)].address;
		sprintf(code, "LOAD %d,%s\n%s %d,%s",temp,opnd1.place,opcode,temp,opnd2.place);
	}
	
	return code;
}


char *newTemp(){

	static int i=1;
	char *temp;
	temp=(char*)malloc(10);
	sprintf(temp,"T%d",i++);
	return temp;
}

void free_reg(){
	
	int i;
	// Free all registers
	for(i=0; i<=reg_top; i++)	reg_descriptor[i].used=0;
	reg_top=0;

}


int checkHash(char arr[],int typeFlag,int status){	//status=DECLARATION or USAGE 

	int i=h(arr), j=0;
	char type[10];

	
	switch(typeFlag){
		case INT: strcpy(type,"int");
				break;
		case FLOAT: strcpy(type,"float");
				break;
		case CHAR: strcpy(type,"char");
				break;
	}
	
	do{
	
		if(symbolTable[(i+j)%TABLE_SIZE]==NULL){
		
			if(status==USAGE)	return UNDECLARED;			
		
			symbolTable[(i+j)%TABLE_SIZE]=(symbol*)malloc(sizeof(symbol));
			strcpy( symbolTable[(i+j)%TABLE_SIZE]->s, arr);
			symbolTable[(i+j)%TABLE_SIZE]->index=id_count++;
			strcpy( symbolTable[(i+j)%TABLE_SIZE]->type, type);
			
			return id_count-1;	//Inserted
		}		
	
		if(!strcmp(arr, symbolTable[ (i+j)%TABLE_SIZE ]->s)){
		
			if(status==DECLARATION)	return REDECLARATION;
			return symbolTable[ (i+j)%TABLE_SIZE ]->index;	//Found
		}
		j++;
	}while(j<TABLE_SIZE);
	return SYMBOL_TABLE_OVERFLOW;
} 

int h(char id[]){

	int i, c=0;
	for(i=0; id[i]; i++)	c+=id[i];
	return c%TABLE_SIZE;
}


yyerror(){

}


