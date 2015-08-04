/* A simple server in the internet domain using TCP
   The port number is passed as an argument 
   This version runs forever, forking off a separate 
   process for each connection
   gcc server2.c -lsocket
*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <sys/stat.h> 
#include <fcntl.h> 
#include <dirent.h>
void dostuff (int sock,char command[10]);
void error(char *msg)
{
    perror(msg);
    exit(1);
}

int main(int argc, char *argv[])
{
     int sockfd, newsockfd, portno, clilen, pid,n;
     struct sockaddr_in serv_addr, cli_addr;
	char command[10];
     if (argc < 2) {
         fprintf(stderr,"ERROR, no port provided\n");
         exit(1);
     }
     sockfd = socket(AF_INET, SOCK_STREAM, 0);
     if (sockfd < 0) 
        error("ERROR opening socket");
     bzero((char *) &serv_addr, sizeof(serv_addr));
     portno = atoi(argv[1]);
     serv_addr.sin_family = AF_INET;
     serv_addr.sin_addr.s_addr = INADDR_ANY;
     serv_addr.sin_port = htons(portno);
     if (bind(sockfd, (struct sockaddr *) &serv_addr,
              sizeof(serv_addr)) < 0) 
              error("ERROR on binding");
     listen(sockfd,5);
     clilen = sizeof(cli_addr);
     while(1) 
     {
         newsockfd = accept(sockfd,(struct sockaddr *) &cli_addr, &clilen);
         if (newsockfd < 0) 
         error("ERROR on accept");
         pid = fork();
         if (pid < 0)
         error("ERROR on fork");
         if (pid == 0)  
         {
		close(sockfd);
		do
		{
		bzero(command,10);
		do
		{
	  		n=read(newsockfd,command,10);
			 if (n < 0) error("ERROR reading from socket");
		}while(n<0);
		printf("command:%s###\n",command);	 
		n=write(newsockfd,"received",10);
		if (n < 0) error("ERROR writing to socket");
		dostuff(newsockfd,command);
				
		}while(strcmp(command,"exit")!=0);

             close(newsockfd);
             exit(0);
   	}
        else 
        {
        	close(newsockfd);
        	continue;
        }
     } /* end of while */
     //close(sockfd);
     return 0; /* we never get here */
}

/******** DOSTUFF() *********************
 There is a separate instance of this function 
 for each connection.  It handles all communication
 once a connnection has been established.
 *****************************************/
void dostuff (int sock,char command[10])
{
   int n,chars_read,fd;
   char buffer[100],filename[256],ack=1,pwd[256];
   //FILE *f_server,*f_client;   
     bzero(filename,256);
  
   //strcpy(temp,buffer);
  
   //printf("Here is the message: %s\n",buffer);
   //n = write(sock,"I got your message",18);
   //strcpy(command,strtok(input," "));
   //strcpy(filename,strtok(NULL,"\n"));
   if(strcmp(command,"get")==0)
   {
   	printf("i am here\n");
   	do
		{
	  		n=read(sock,filename,256);
			 if (n < 0) error("ERROR reading from socket");
		}while(n<0);
			 
		n=write(sock,"received",10);
		if (n < 0) error("ERROR writing to socket");
   //strcpy(temp,buffer);
   //if (n < 0) error("ERROR reading from socket");
   	printf("filename: %sfjhgtj\n",filename);
   	//f_client=fopen(argument,"r");
	
   	fd=open(filename, O_RDONLY);
   	//f_client=fopen(dest_filename,"w+");
   	chars_read=100;
   	while(chars_read==100)
   	{
   		printf("inside while\n");
   		chars_read=read(fd,buffer,100);
   		if(chars_read<0)   		
   			printf("error reading file\n");
   		n=write(sock,buffer,chars_read);

   		printf("@@@@%s@@@@\n",buffer);
   		printf("%d\n",chars_read);
   		if (n < 0) 
   			error("ERROR writing to socket");
   			//fwrite(content,1,1,f_client);
	
      	}
   	//write(sock,"#",1);
   	close(fd);
   	//close(sock);
   	//fclose(f_client);
   }
   
   
   if(strcmp(command,"put")==0)
   {
   	printf("i am here\n");
   	n = read(sock,filename,256);
   	chars_read=100;
   	//strcpy(filename,strtok(filename,'#'));
   //strcpy(temp,buffer);
   if (n < 0) error("ERROR reading from socket");
  
   	printf("filename: %sfjhgtj\n",filename);
   	//f_client=fopen(argument,"r");
   	 fd=open(filename, O_WRONLY);
	       if(fd<0)
	       	fd=creat(filename,O_WRONLY);
	    while(chars_read==100)
	    {
		printf("in while\n");
	    	chars_read=read(sock,buffer,100);
	    	if (chars_read < 0) 
		  error("ERROR reading from socket");
		write(fd,buffer,chars_read);
	      }
	      
	      close(fd);
	      //close(sock);
   }
   
   else  if(strcmp(command,"exit")==0)
   {
   
   	return;
   }
   
  else if(strcmp(command,"ls\n")==0)
{
	//char pwd[256];
	
	DIR *d,*d1;
	  
	  
	  struct dirent *dir;
	  
	  int count,choice,i;
	  //char pwd1[100];
	 
	  //strcpy(pwd1,pwd);
	  //strcat(pwd1,"/");
	  
	  //cout<<"here1"<<endl;
	  count=0;
	 char name[1000][100];
	  
	  d = opendir(pwd);
	 
	//readdir(d);
	  if (d)//loading contents into array
	  {
	    while ((dir = readdir(d)) != NULL)
	    {
	    	//cout<<dir->d_name<<endl;
	    if(strcmp(dir->d_name,".")==0)
	  	{
	  		//cout<<"here"<<endl;
	  		continue;
	  	}
	  	
	  	strcpy(name[count],dir->d_name);
	    	count++;
	    	//cout<<count<<dir->d_name<<endl;    	
	    }
	    
	  }
	
   } 
   printf("end of dostuff\n");
}
