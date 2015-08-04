#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include<strings.h> 
#include<string.h>
#include<stdlib.h> 
//extra headers..................................
#include <netpacket/packet.h>
#include <net/ethernet.h> /* For DLL protocols */

#include<netinet/ip.h>
#include<netinet/tcp.h>



int main()
{
	int i,sockfd, len,size;
	char buffer[1024];
	struct sockaddr_ll pla;
	struct ip *iph;
	
	if( (sockfd=socket(PF_INET,SOCK_RAW,IPPROTO_TCP)) <0 )
	{
		perror("socket");
		exit(0);
	}
	
	len = sizeof(struct sockaddr_ll);
	while( (size=recvfrom(sockfd,buffer,1024,0,(struct sockaddr *)&pla,&len)) >0)
	{
		iph=(struct ip*)buffer;
		printf("Found Packet:\nSrc:%s\nDest:%s\n\n",inet_ntoa(iph->ip_src),inet_ntoa(iph->ip_dst));
	
	}
	
	
	return 0;
}

