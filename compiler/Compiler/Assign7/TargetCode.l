%{
	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	
	int s;
	int var[3];
	char *sym[2];
	int varNum=0;
	int symNum=0;
	char *R[20][2];
	char *lab;
	int addr;
	int not,f1,vgoto;
	FILE *fpm;
	char *file;
	int labN;
	struct l{
		char name[3];
		int adress;
	} label[10];
%}


%%
"\n"			{
				if(not==1){
					not=0;
				}

				else if(f1==1 && vgoto==1){
					f1=0;vgoto=0;
					fprintf(fpm,"%s  \n",lab);
					strcpy(label[labN++].name,lab);
					clearReg();
				}

				else if(vgoto==1){
					vgoto=0;
					fprintf(fpm,"%d\tJMP %s  \n",addr,lab);
					addr=addr+3;

					for(s=0;s<labN;s++)
						if(strcmp(label[s].name,lab)==0)
							break;	
					if(s==labN)
						strcpy(label[labN++].name,lab);
					clearReg();
				}

				else if(var[1]!=-1 && var[2]!=-1){
					if(var[2]<12){
						fprintf(fpm,"%d\tLDA %sh\n",addr,R[var[2]][0]);
						fprintf(fpm,"%d\tMOV B, A\n",addr+3);
						addr=addr+4;					
					}
					else
						fprintf(fpm,"%d\tMOV B, %s\n",addr++,R[var[2]][0]);


					if(var[1]<12){
						fprintf(fpm,"%d\tLDA %sh\n",addr,R[var[1]][0]);
						addr=addr+3;
					}
					else
						fprintf(fpm,"%d\tMOV A, %s\n",addr++,R[var[1]][0]);

					

					if(sym[1][0]=='+')
						fprintf(fpm,"%d\tADD B\n",addr++);		
					else if(sym[1][0]=='-')
						fprintf(fpm,"%d\tSUB B\n",addr++);
					else if(sym[1][0]=='*')
						multiply();
					else if(sym[1][0]=='/')
						divide();
					else if(sym[1][0]=='<'){
						fprintf(fpm,"%d\tSUB B\n",addr++);
						fprintf(fpm,"%d\tJP ",addr);
						addr=addr+3;
					}
					else if(sym[1][0]=='>'){
						fprintf(fpm,"%d\tSUB B\n",addr++);
						fprintf(fpm,"%d\tJM ",addr);
						addr=addr+3;
					}
					else if(sym[1][0]=='='){
						fprintf(fpm,"%d\tSUB B\n",addr++);
						fprintf(fpm,"%d\tJNZ ",addr);
						addr=addr+3;
					}
					
					if(sym[1][0]!='<' && sym[1][0]!='>' && sym[1][0]!='='){
						if(var[0]<12){
							fprintf(fpm,"%d\tSTA %sh\n",addr,R[var[0]][0]);
							addr=addr+3;
						}
						else
							fprintf(fpm,"%d\tMOV %s, A\n",addr++,R[var[0]][0]);
					}
				}

				else if(var[2]==-1 && var[1]!=-1){
					fprintf(fpm,"%d\tSTA %sh\n",addr,R[var[0]][0]);
					addr=addr+3;
					clearReg();
				}

				yylineno++;
				varNum=0;
				symNum=0;	
				sym[0][0]='\0';
				sym[1][0]='\0';
				var[0]=-1;
				var[1]=-1;
				var[2]=-1;
			}

"NOT"		{
				not=1;
			}

"if"			{
				f1=1;
			}

"GOTO"			{
				vgoto=1;
			}

L[0-9]*:		{
				for(s=0;s<10;s++)
					if(yytext[s]==':'){
						yytext[s]='\0';
						break;
					}
				for(s=0;s<labN;s++)
					if(strcmp(label[s].name,yytext)==0){
						label[s].adress=addr;
						break;	
					}
				if(s==labN){
					strcpy(label[labN].name,yytext);
					label[labN++].adress=addr;
				}
			}

L[0-9]*			{
				strcpy(lab,yytext);	
			}

t[0-9]*			{
				s=searchVariable(yytext);
				if(s==-1){
					s=searchFreeReg();
					strcpy(R[s][1],yytext);
					var[varNum++]=s;
				}
				else
					var[varNum++]=s;
					
			}

[a-zA-Z][A-Za-z0-9]*		{
				if((s=searchVariable(yytext))!=-1)
					var[varNum++]=s;
				else{
					s=searchFreeMem();
					strcpy(R[s][1],yytext);
					var[varNum++]=s;
				}	
			}

[==]*[+]*[-]*[*]*[/]*[>]*[<]*[=]*	{
				strcpy(sym[symNum++],yytext);

			}

[1-9][1-9]*		{
				return 1;
			}

.			{;}
%%



extern void *malloc();
extern FILE *yyin;

int main(){
	int i,j;

	sym[0]=(char *)malloc(5);
	sym[1]=(char *)malloc(5);
	sym[0][0]='\0';
	sym[1][0]='\0';
	var[0]=-1;
	var[1]=-1;
	var[2]=-1;
	addr=0;
	labN=0;
	lab=(char *)malloc(5);
	file=(char *)malloc(5000);
	for(i=0;i<20;i++)
		for(j=0;j<2;j++)
			R[i][j]=(char *)malloc(5);

	strcpy(R[0][0],"8000");
	strcpy(R[1][0],"8001");
	strcpy(R[2][0],"8002");
	strcpy(R[3][0],"8003");
	strcpy(R[4][0],"8004");
	strcpy(R[5][0],"8005");
	strcpy(R[6][0],"8006");
	strcpy(R[7][0],"8007");
	strcpy(R[8][0],"8008");
	strcpy(R[9][0],"8009");
	strcpy(R[10][0],"8010");
	strcpy(R[11][0],"8011");
	strcpy(R[12][0],"A");
	strcpy(R[13][0],"B");
	strcpy(R[14][0],"C");
	strcpy(R[15][0],"D");
	strcpy(R[16][0],"E");
	strcpy(R[17][0],"F");
	strcpy(R[18][0],"H");
	strcpy(R[19][0],"L");

	fpm=fopen("tcode.txt","w");
	while(yylex());
	fclose(fpm);
	fpm=fopen("tcode.txt","r");
	for(s=0;(file[s]=getc(fpm))!=EOF;s++);
	file[s]='\0';
	fclose(fpm);
	
	for(s=0;s<labN;s++){
		i=searchL(label[s].name,file);	
		ToChar(label[s].adress,lab);
		for(j=0;lab[j]!='\0';j++,i++)
			file[i]=lab[j];
		while(j++<=3)
			file[i++]=' ';
	}
	fpm=fopen("tcode.txt","w");
	for(s=0;file[s]!='\0';s++)
		putc(file[s],fpm);
	return 0;	
}

int searchVariable(char *c){
	int i;	
	for(i=0;i<=11;i++)
		if(strcmp(R[i][1],c)==0)
			return i;
	for(i=14;i<=19;i++)
		if(strcmp(R[i][1],c)==0)
			return i;
	return -1;
}

int searchFreeReg(){
	int i;
	for(i=14;i<=19;i++) 		
		if(R[i][0][0]!='F' && R[i][1][0]=='\0')
			return i;
}

int searchFreeMem(){
	int i;
	for(i=0;i<=11;i++) 		
		if(R[i][1][0]=='\0')
			return i;
}

clearReg(){
	int i;
	for(i=14;i<=19;i++) 		
		R[i][1][0]='\0';
}

divide(){
	int i;
	i=searchFreeReg();
	fprintf(fpm,"%d\tMVI %s, 00h\n",addr,R[i][0]);
	addr=addr+2;
	fprintf(fpm,"%d\tSUB B\n",addr++);
	fprintf(fpm,"%d\tJM %d\n",addr,addr+7);
	addr=addr+3;
	fprintf(fpm,"%d\tINR %s\n",addr++,R[i][0]);
	fprintf(fpm,"%d\tJMP %d\n",addr,addr-5);
	addr=addr+3;
	fprintf(fpm,"%d\tMOV A, %s\n",addr++,R[i][0]);	
}

multiply(){
	int i;
	i=searchFreeReg();
	fprintf(fpm,"%d\tMOV %s, A\n",addr++,R[i][0]);
	fprintf(fpm,"%d\tDCR B\n",addr++);
	fprintf(fpm,"%d\tJZ %d\n",addr,addr+7);
	addr=addr+3;
	fprintf(fpm,"%d\tADD %s\n",addr++,R[i][0]);
	fprintf(fpm,"%d\tJMP %d\n",addr,addr-5);
	addr=addr+3;	
}

int searchL(char *x, char *y) {
	int i, j,m,n;
	m=strlen(x);
	n=strlen(y);
	for (j = 0; j <= n - m; ++j) {
		for (i = 0; i < m && x[i] == y[i + j]; ++i);
		if (i >= m)
		return(j);
	}
}

ToChar(int i,char *c){
	int j,k,l=4;
	while(i!=0){
		k=i%10;	
		c[l--]=k+'0';
		i=i/10;
	}
	l++;
	for(j=0;l<=4;j++,l++)
		c[j]=c[l];
	c[j]='\0';
}
