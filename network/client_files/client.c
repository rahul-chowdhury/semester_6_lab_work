#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h> 
#include <stdlib.h>
#include <sys/stat.h> 
#include <fcntl.h> 
void error(char *msg)
{
    perror(msg);
    exit(0);
}

int main(int argc, char *argv[])
{
    int sockfd, portno, n,chars_read=10;
    struct sockaddr_in serv_addr;
    struct hostent *server;
    char buffer[100],input[256],filename[256],command[10],ack[10];
    if (argc < 3) 
    {
       fprintf(stderr,"usage %s hostname port\n", argv[0]);
       exit(0);
    }
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(argv[1]);
    if (server == NULL) 
    {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }     
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr,(char *)&serv_addr.sin_addr.s_addr,server->h_length);
    serv_addr.sin_port = htons(portno);
    if (connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    printf("here\n");
    
   
    do
    {
		printf("Please enter the message: ");
		//bzero(input,256);
		fgets(input,256,stdin);
		// printf("filename: %sfjhgtj\n",input);
		strcpy(command,strtok(input," \n")); //extracting command from the input
				   
	     //printf("filenmae: %sfjhgtj\n",filename);
	     printf("command: %sfjhgtj\n",command);
	     int i=10;
	     while(i-- !=0){}
	     do
	     {
	     n = write(sockfd,command,10);
	     if (n < 0) 
		 error("ERROR writing to socket");
		 n = read(sockfd,ack,10);
	     		if (n < 0) 
		 		error("ERROR reading from socket");
		 		
		 }while(strcmp(ack,"received")!=0);
		 
	     if(strcmp(command,"exit")==0) 
	     {
	     	break;
	     }	
	     if(strcmp(command,"get")==0)
	     {
			strcpy(filename,strtok(NULL,"\n"));
		   	printf("filename: %sfjhgtj\n",filename);
		   	chars_read=100;
			do
	     {
	     n = write(sockfd,filename,256);
	     if (n < 0) 
		 error("ERROR writing to socket");
		 n = read(sockfd,ack,10);
	     		if (n < 0) 
		 		error("ERROR reading from socket");
		 		
		 }while(strcmp(ack,"received")!=0);	 
		       bzero(buffer,100);
		       int fd=open(filename, O_WRONLY);
		        if(fd<0)
		       	      fd=creat(filename,O_WRONLY);
		      while(chars_read==100)
		      {
			 printf("in loop\n");
		    	 chars_read=read(sockfd,buffer,10);
		    	 if (chars_read < 0) 
			     error("ERROR reading from socket");
			printf("%d\n",chars_read);
			 write(fd,buffer,chars_read);
		       }
		      //printf("end of while\n");
		      close(fd);
		      //close(sockfd);
	     } 
		     
		    if(strcmp(command,"put")==0)
		   {
				strcpy(filename,strtok(NULL,"\n"));
			   	printf("i am here\n");
			   	
				n = write(sockfd,filename,256);
				chars_read=10;
			       if (n < 0) 
				 error("ERROR writing to socket");
				 
			       bzero(buffer,100);
			       int fd=open(filename, O_RDONLY);
		   	//f_client=fopen(dest_filename,"w+");
		   	chars_read=100;
		   	while(chars_read==100)
		   	{
		   		printf("inside while\n");
		   		chars_read=read(fd,buffer,100);
		   		if(chars_read<0)   		
		   			printf("error reading file\n");
		   		n=write(sockfd,buffer,chars_read);
		   		printf("@@@@%s@@@@\n",buffer);
		   		printf("inside while2\n");
		   		if (n < 0) 
		   			error("ERROR writing to socket");
		   			//fwrite(content,1,1,f_client);
		      	}
		   	//write(sock,"#",1);
		   	close(fd);
		   	//close(sockfd);
		     }
	 //printf("Please enter the message: ");
		    //bzero(input,256);
		   // fgets(input,256,stdin);
		   // printf("filename: %sfjhgtj\n",input);
		   // strcpy(command,strtok(input," \n"));
		        
	}while(strcmp(command,"exit")!=0);//till user enters exit command;
        close(sockfd);
    //printf("%s\n",buffer);
    return 0;
}
