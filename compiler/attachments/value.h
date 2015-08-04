typedef struct{
	char code[1000];
	char place[20];
	int operand_index;	//index in the operand descriptor table
}value;

typedef struct{
	char mode;	// 'S' or 'R'
	int address;	//The index field in symbol table is considered as the address when mode is 'S'
}operand;
	 
