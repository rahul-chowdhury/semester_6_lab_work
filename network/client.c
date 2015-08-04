#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <stdlib.h>
void error(char *msg)
{
    perror(msg);
    exit(0);
}

int main(int argc, char *argv[])
{
    int sockfd, portno, n;

    struct sockaddr_in serv_addr;
    struct hostent *server;

    char buffer[256],input[256],pwd[256],word[256];
    getcwd(pwd,256);
    if (argc < 3) {
       fprintf(stderr,"usage %s hostname port\n", argv[0]);
       exit(0);
    }
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(argv[1]);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    printf("Please enter the message: ");
    bzero(input,256);
    fgets(input,255,stdin);
    
     if(strcmp(input,"lls\n")==0)
{
	//printf("here\n");
	system("ls");
}

   if(strcmp(input,"ls\n")==0)
{
	n = write(sockfd,input,strlen(input));
	if (n < 0) 
         error("ERROR writing to socket");
}


//strcpy(word,strtok(input," \n"));
else if(strcmp(strcpy(word,strtok(input," \n")),"lcd")==0)
{
	strcpy(word,strtok(NULL,"\n"));
	char address[100];
	strcpy(address,pwd);
	strcat(address,"/");
	strcat(address,word);
	//strcpy(pwd,address);
	char temp1[256];getcwd(temp1,256);
	printf("here\n");
	int i=chdir(address);
	getcwd(pwd,256);
	if(i==-1)
	{
	printf("no such file or directory\n");
	fflush(stdout);
	chdir(temp1);
	}
}

else 
{

    n = write(sockfd,input,strlen(input));
    strcpy(word,strtok(NULL,"\n"));
     printf("word:%sfjhgtj\n",word); 
    if (n < 0) 
         error("ERROR writing to socket");
    bzero(buffer,256);
    n = read(sockfd,buffer,255);
    if (n < 0) 
        error("ERROR reading from socket");
       if(strcmp(buffer,"command received")==0)
     {   
    n = write(sockfd,word,255);
    
    
    if (n < 0) 
         error("ERROR writing to socket");
        }
    //bzero(buffer,256);
    //n = read(sockfd,buffer,255);
   // if (n < 0) 
     //    error("ERROR reading from socket");
    printf("%s\n",buffer);
}
   
    return 0;
}
