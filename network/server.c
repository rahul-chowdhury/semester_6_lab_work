/* A simple server in the internet domain using TCP
   The port number is passed as an argument 
   This version runs forever, forking off a separate 
   process for each connection
   gcc server2.c -lsocket
*/
#include <stdio.h>
#include <dirent.h> 
#include <stdlib.h>
#include <string.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <pwd.h>
char pwd[256];
void dostuff(int); /* function prototype */
void error(char *msg)
{
    perror(msg);
    exit(1);
}

int main(int argc, char *argv[])
{
     int sockfd, newsockfd, portno, clilen, pid;
     struct sockaddr_in serv_addr, cli_addr;
	 getcwd(pwd,256);
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
     while (1) {
         newsockfd = accept(sockfd, 
               (struct sockaddr *) &cli_addr, &clilen);
         if (newsockfd < 0) 
             error("ERROR on accept");
         pid = fork();
         if (pid < 0)
             error("ERROR on fork");
         if (pid == 0)  {
             close(sockfd);
             dostuff(newsockfd);
             exit(0);
         }
         else close(newsockfd);
     } /* end of while */
     return 0; /* we never get here */
}

/******** DOSTUFF() *********************
 There is a separate instance of this function 
 for each connection.  It handles all communication
 once a connnection has been established.
 *****************************************/
void dostuff (int sock)
{
   int n,size_read;
   char buffer[256],temp[256],command[256],argument[256],content[10],word[256];
   FILE *f;  
  
   //getcwd(pwd,256); 
   printf("current directory is:%sfjhgtj\n",pwd);
   bzero(buffer,256);
   n = read(sock,buffer,255);
   strcpy(temp,buffer);
   if (n < 0) error("ERROR reading from socket");
   //printf("Here is the message: %s\n",buffer);
   //n = write(sock,"I got your message",18);
   strcpy(command,strtok(temp," "));
   printf("command: %sfjhgtj\n",command);
   if(strcmp(command,"get")==0)
   {
   	printf("i am here\n");
   	strcpy(argument,strtok(NULL,"\n"));
   	printf("filename: %sfjhgtj\n",argument);
   	f=fopen(argument,"r");
   	
   	size_read=1;
   	while(size_read==1)
   	{
   		printf("inside while\n");
   		size_read=fread(content,sizeof(content),1,f);
   		printf("size: %d\n",size_read);
   		printf("hahah\n");
   		write(sock,content,sizeof(content));
   		printf("lalal\n");
   	}
   }
if(strcmp(buffer,"ls\n")==0)
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
	      
	  /*else
	  {
	  	//cout<<"THIS IS NOT A DIRECTORY!!ENTER INPUT AGAIN"<<endl;
		//char filename[100],path[100];
	  	//cout<<"select file/folder name from the list"<<endl;
	  	//cin>>filename;
	  	//strcpy(path,pwd1);
	  	//strcat(path,filename);
	  	struct stat buf; 
	    	stat (pwd, &buf);
	    	struct group *grp;
	struct passwd *kwd;

	kwd = getpwuid(buf.st_uid);
	printf("OWNER NAME: %s\n", kwd->pw_name);
	grp = getgrgid(buf.st_gid);
	printf("GROUP NAME: %s\n", grp->gr_name);



	    	cout<<"OWNER PERMISSIONS: ";
	    	if( buf.st_mode & S_IRUSR)
	    		printf("read ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IWUSR)
	    		printf("write ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IXUSR)
	    		printf("execute\n");
	    	else printf("\n");
	    	cout<<"GROUP PERMISSIONS: ";
	    	if( buf.st_mode & S_IRGRP)
	    		printf("read ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IWGRP)
	    		printf("write ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IXGRP)
	    		printf("execute	   \n");
	    	else printf("\n");
	    	cout<<"OTHERS PERMISSIONS: ";
	    	if( buf.st_mode & S_IROTH)
	    		printf("read ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IWOTH)
	    		printf("write ");
	    	else printf(" ");
	    	if( buf.st_mode & S_IXOTH)
	    		printf("execute");
	    	else printf(" ");
	    	printf("\n");
	  	return;
	  }*/
	  //for(i=0;i<count;i++)
	  //cout<<name[i]<<endl;
		int k;
	  for (i = 0; i < count-1; i++) { 
		    for ( k = i+1; k < count; k++) { 
		        if (strcmp(name[i], name[k])>0) { 
		             char tmp[100];
		            strcpy(tmp,name[i]); 
		            strcpy(name[i] ,name[k]); 
		            strcpy(name[k],tmp); 
		        } 
		    } 
		} 
	  closedir(d);
	  
	  //count=0;
	 // d = opendir(pwd);
	 
	 if (d)//printing contents
	  {
	  	printf("****FILE LIST****\n");
	  	//cout<<"0.	EXIT"<<endl;
		//readdir(d);

	    	for(i=0;i<count;i++)
	    	{
	    		
	    		
	    			printf("%d.\t%s\n",i+1, name[i]);
	    			
	  	//if(strcmp(name[i],"..")==0)
	  		//cout<<"(Parent directory)"<<endl;
	  	/*else
	  	{
	  		char temp[100];
	  		strcpy(temp,pwd1);
	  		strcat(temp,name[i]);
	    		d1=opendir(temp);
	    		if(d1)
	    			cout<<"(folder)"<<endl;
	    		else
	    			cout<<"(file)"<<endl;
	    			closedir(d1);
	    			
	    	}*/
	    		
	    	}	
	    //cout<<count+1<<".\tSEE FILE/FOLDER PERMISSIONS\n\n";
	   
	  } 
}
if(strcmp(command,"cd")==0)
{
	write(sock,"command received",16);
	 n = read(sock,word,255);
	 printf("word:%sfjhgtj\n",word);
	printf("inside cd\n");
	char address[100];
	strcpy(address,pwd);
	strcat(address,"/");
	strcat(address,word);
	//strc(pwd,address);py
	char temp1[256];getcwd(temp1,256);
	
	int i=chdir(address);
	getcwd(pwd,256);
	printf("new directory:%s\n",pwd);
	if(i==-1)
	{
	printf("no such file or directory\n");
	fflush(stdout);
	chdir(temp1);
	}
}

if(strcmp(command,"lls")==0)
{
	return;
}
    
   if (n < 0) error("ERROR writing to socket");
}
