#include <sys/types.h>
//#include <sys/stat.h>
//#include <fcntl.h>
#include <sys/socket.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/if_packet.h>
#include <net/ethernet.h> 
#include <unistd.h>

int main(int argc, char *argv[])
{
	char buff[256];
    int pack_sockfd,newsockfd, portno, pid;
    struct sockaddr_ll sll;
	bzero(&sll,sizeof(struct sockaddr_ll));
	//portno = atoi(argv[1]);
	pack_sockfd = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if(pack_sockfd == -1)
	{
		perror("sockets");
		exit(0);
	}
	/*Bind raw socket to the interface*/
	sll.sll_family=AF_PACKET;	
	sll.sll_protocol=ETH_P_ALL;
	sll.sll_ifindex=0;

	if( bind(pack_sockfd,(struct sockaddr *) &sll, sizeof (sll)) == -1)
	{
		perror("bind_error");
		exit(0);
	}

	while (1)
	{
	printf("%s\n",buff);
       	recvfrom(pack_sockfd, buff, sizeof(buff), 0, (struct sockaddr *)&sll, (socklen_t *)sizeof(sll));
		
   }
   return 0;
}
