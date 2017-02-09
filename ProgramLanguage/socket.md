# Socket网络编程相关 #
*****************
## Socket基础概念 ##
> 在本地可以通过进程PID来唯一标识一个进程，但是在网络中这是行不通的。其实TCP/IP协议族已经帮我们解决了这个问题，网络层的“ip地址”可以唯一标识网络中的主机，而传输层的“协议+端口”可以唯一标识主机中的应用程序（进程）。这样利用三元组（ip地址，协议，端口）就可以标识网络的进程了，网络中的进程通信就可以利用这个标志与其它进程进行交互。  

Socket遵循“一切皆文件”的基本哲学，可以用“open->read/write->close”模式来进行操作。
## Socket基本操作 ##
1.socket()函数  
`int socket(int domain,int type,int protocol);`  

- domain：即协议域，又称为协议族（family）。常用的协议族有，AF_INET、AF_INET6、AF_LOCAL（或称AF_UNIX，Unix域socket）、AF_ROUTE等等。协议族决定了socket的地址类型，在通信中必须采用对应的地址，如AF_INET决定了要用ipv4地址（32位的）与端口号（16位的）的组合、AF_UNIX决定了要用一个绝对路径名作为地址。
- type：指定socket类型。常用的socket类型有，SOCK_STREAM、SOCK_DGRAM、SOCK_RAW、SOCK_PACKET、SOCK_SEQPACKET等等（socket的类型有哪些？）。
- protocol：故名思意，就是指定协议。常用的协议有，IPPROTO_TCP、IPPTOTO_UDP、IPPROTO_SCTP、IPPROTO_TIPC等，它们分别对应TCP传输协议、UDP传输协议、STCP传输协议、TIPC传输协议  

*type与protocol不可随意组合，SOCK_STREAM对应Tcp协议，SOCK_DGRAM对应Udp协议，protocol为0时会自动选择与type相对应的protocol*  

当我们调用socket创建一个socket时，返回的socket描述字它存在于协议族（address family，AF_XXX）空间中，但没有一个具体的地址。如果想要给它赋值一个地址，就必须调用bind()函数，否则就当调用connect()、listen()时系统会自动随机分配一个端口。  

2.bind()函数  
`int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);`  
该函数把一个特定的地址和端口号组合赋给socket。  

- sockfd：即socket描述字，由`socket()`函数创建  
- addr:指向要绑定给sockfd的协议地址（改地址结构随协议族改变而改变),绑定之前需要把主机字节序转换为网络字节序  
- addelen:对应`struct sockaddr`的长度  

通常服务器在启动的时候都会绑定一个众所周知的地址（如ip地址+端口号），用于提供服务，客户就可以通过它来接连服务器；而客户端就不用指定，有系统自动分配一个端口号和自身的ip地址组合。这就是为什么通常服务器端在listen之前会调用bind()，而客户端就不会调用，而是在connect()时由系统随机生成一个。  

3.listen()、connect()函数  
`int listen(int sockfd,int backlog)`  
`int connect(int sockfd,const struct sockaddr *addr,socklen_t addrlen)`  

- 服务器调用`listen()`之后等待客户端调用`connect()`进行连接  
- backlog:对应sockfd允许的最大连接个数  

4.accept()函数  
`int accept(int sockfd,struct sockaddr* addr,socklen_t addrlen)`  

- addr:返回客户端的协议地址  

*accept的第一个参数为服务器的socket描述字，是服务器开始调用socket()函数生成的，称为监听socket描述字；而accept函数返回的是已连接的socket描述字。一个服务器通常通常仅仅只创建一个监听socket描述字，它在该服务器的生命周期内一直存在。内核为每个由服务器进程接受的客户连接创建了一个已连接socket描述字，当服务器完成了对某个客户的服务，相应的已连接socket描述字就被关闭。*  

5.read()、write()等函数  

	#include <unistd.h>
	ssize_t read(int fd, void *buf, size_t count);
	ssize_t write(int fd, const void *buf, size_t count);
	
	#include <sys/types.h>
	#include <sys/socket.h>
	
	ssize_t send(int sockfd, const void *buf, size_t len, int flags);
	ssize_t recv(int sockfd, void *buf, size_t len, int flags);
	
	ssize_t sendto(int sockfd, const void *buf, size_t len, int flags,
	              const struct sockaddr *dest_addr, socklen_t addrlen);
	ssize_t recvfrom(int sockfd, void *buf, size_t len, int flags,
	                struct sockaddr *src_addr, socklen_t *addrlen);
	//推荐使用这两个  其它的可以很方便的转换过来
	ssize_t sendmsg(int sockfd, const struct msghdr *msg, int flags);
	ssize_t recvmsg(int sockfd, struct msghdr *msg, int flags);

read函数是负责从fd中读取内容.当读成功时，read返回实际所读的字节数，如果返回的值是0表示已经读到文件的结束了，小于0表示出现了错误。如果错误为EINTR说明读是由中断引起的，如果是ECONNREST表示网络连接出了问题。

write函数将buf中的nbytes字节内容写入文件描述符fd.成功时返回写的字节数。失败时返回-1，并设置errno变量。 在网络程序中，当我们向套接字文件描述符写时有俩种可能。1)write的返回值大于0，表示写了部分或者是全部的数据。2)返回的值小于0，此时出现了错误。我们要根据错误类型来处理。如果错误为EINTR表示在写的时候出现了中断错误。如果为EPIPE表示网络连接出现了问题(对方已经关闭了连接)。  

6.close()函数  
`int close(int fd);`  
close一个TCP socket的缺省行为时把该socket标记为以关闭，然后立即返回到调用进程。该描述字不能再由调用进程使用，也就是说不能再作为read或write的第一个参数。

注意：close操作只是使相应socket描述字的引用计数-1，只有当引用计数为0的时候，才会触发TCP客户端向服务器发送终止连接请求。



## Tcp过程 ##

1.三次握手连接过程如下：  
![](http://images.cnblogs.com/cnblogs_com/skynet/201012/201012122157467258.png "三次握手过程")

**总结：客户端的connect在三次握手的第二个次返回，而服务器端的accept在三次握手的第三次返回。**

2.四次分手过程如下：  
![](http://images.cnblogs.com/cnblogs_com/skynet/201012/201012122157487616.png "四次分手过程")


## 一个栗子--Tcp ##
1.示例图：  
![](http://images.cnblogs.com/cnblogs_com/chenxizhang/WindowsLiveWriter/TCPUDP_EF8C/image_2.png "Tcp示例图")

2.服务器代码：  

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<errno.h>
	#include<sys/types.h>
	#include<sys/socket.h>
	#include<netinet/in.h>
	
	#define MAXLINE 4096
	int main(int argc, char** argv)
	{
	    int    listenfd, connfd;
	    struct sockaddr_in     servaddr;
	    char    buff[4096];
	    int     n;
	
	    if( (listenfd = socket(AF_INET, SOCK_STREAM, 0)) == -1 ){
	    printf("create socket error: %s(errno: %d)\n",strerror(errno),errno);
	    exit(0);
	    }
	
	    memset(&servaddr, 0, sizeof(servaddr));
	    servaddr.sin_family = AF_INET;
	    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
	    servaddr.sin_port = htons(6666);
	
	    if( bind(listenfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) == -1){
	    printf("bind socket error: %s(errno: %d)\n",strerror(errno),errno);
	    exit(0);
	    }
	
	    if( listen(listenfd, 10) == -1){
	    printf("listen socket error: %s(errno: %d)\n",strerror(errno),errno);
	    exit(0);
	    }
	
	    printf("======waiting for client's request======\n");
	    while(1){
	    if( (connfd = accept(listenfd, (struct sockaddr*)NULL, NULL)) == -1){
	        printf("accept socket error: %s(errno: %d)",strerror(errno),errno);
	        continue;
	    }
	    n = recv(connfd, buff, MAXLINE, 0);
	    buff[n] = '\0';
	    printf("recv msg from client: %s\n", buff);
	    close(connfd);
	    }
	
	    close(listenfd);
	}
	
3.客户端代码：  

	#include<stdio.h>
	#include<stdlib.h>
	#include<string.h>
	#include<errno.h>
	#include<sys/types.h>
	#include<sys/socket.h>
	#include<netinet/in.h>
	
	#define MAXLINE 4096
	
	int main(int argc, char** argv)
	{
	    int    sockfd, n;
	    char    recvline[4096], sendline[4096];
	    struct sockaddr_in    servaddr;
	
	    if( argc != 2){
	    printf("usage: ./client <ipaddress>\n");
	    exit(0);
	    }
	
	    if( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0){
	    printf("create socket error: %s(errno: %d)\n", strerror(errno),errno);
	    exit(0);
	    }
	
	    memset(&servaddr, 0, sizeof(servaddr));
	    servaddr.sin_family = AF_INET;
	    servaddr.sin_port = htons(6666);
	    if( inet_pton(AF_INET, argv[1], &servaddr.sin_addr) <= 0){
	    printf("inet_pton error for %s\n",argv[1]);
	    exit(0);
	    }
	
	    if( connect(sockfd, (struct sockaddr*)&servaddr, sizeof(servaddr)) < 0){
	    printf("connect error: %s(errno: %d)\n",strerror(errno),errno);
	    exit(0);
	    }
	
	    printf("send msg to server: \n");
	    fgets(sendline, 4096, stdin);
	    if( send(sockfd, sendline, strlen(sendline), 0) < 0)
	    {
	    printf("send msg error: %s(errno: %d)\n", strerror(errno), errno);
	    exit(0);
	    }
	
	    close(sockfd);
	    exit(0);
	}

## 另一个栗子--Udp ##
1.示例图：  
![](http://images.cnblogs.com/cnblogs_com/chenxizhang/WindowsLiveWriter/TCPUDP_EF8C/image_4.png "Udp示例图")

2.服务器代码：  

	#include <stdio.h>
	#include <stdlib.h>
	#include <errno.h>
	#include <string.h>
	#include <sys/types.h>
	#include <netinet/in.h>
	#include <sys/socket.h>
	#include <sys/wait.h>
	#define MYPORT 3490 /* 监听端口 */
	void main()
	{
		int sockfd; /* 数据端口 */
		struct sockaddr_in my_addr; /* 自身的地址信息 */
		struct sockaddr_in their_addr; /* 连接对方的地址信息 */
		int sin_size, retval;
		char buf[128];
		if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1) {
			perror("socket");
			exit(1);
		}
		my_addr.sin_family = AF_INET;
		my_addr.sin_port = htons(MYPORT); /* 网络字节顺序 */
		my_addr.sin_addr.s_addr = INADDR_ANY; /* 自动填本机IP */
		bzero(&(my_addr.sin_zero), 8); /* 其余部分置0 */
		if (bind(sockfd, (struct sockaddr *)&my_addr, sizeof(my_addr)) == -1) {
			perror("bind");
			exit(1);
		}
		/* 主循环 */
		while(1) { 
			retval = recvfrom(sockfd, buf, 128, 0, (struct sockaddr *)&their_addr, &sin_size);
			printf("Received datagram from %s\n",inet_ntoa(their_addr.sin_addr));
			if (retval == 0) {
				perror (“recvfrom");
				close(sockfd);
				break;
			}
			retval = sendto(sockfd, buf, 128, 0, (struct sockaddr *)&their_addr, sin_size);
		}
	}
3.客户端代码：  

	#include <stdio.h>
	#include <stdlib.h>
	#include <errno.h>
	#include <string.h>
	#include <netdb.h>
	#include <sys/types.h>
	#include <netinet/in.h>
	#include <sys/socket.h>
	#define PORT 3490 /* Server的端口 */
	#define MAXDATASIZE 100 /*一次可以读的最大字节数 */
	
	int main(int argc, char *argv[])
	{
	
		int sockfd, numbytes, sin_size;
		char buf[MAXDATASIZE] = “Hello, world!”;
		struct hostent *he; /* 主机信息 */
		struct sockaddr_in their_addr; /* 对方地址信息 */
		if (argc != 2) {
			fprintf(stderr,"usage: client hostname\n");
			exit(1);
		}
		/* get the host info */
		if ((he=gethostbyname(argv[1])) == NULL) {
			herror("gethostbyname");
			exit(1);
		}
		if ((sockfd=socket(AF_INET,SOCK_DGRAM,0))==-1) {
			perror("socket");
			exit(1);
		}
		their_addr.sin_family = AF_INET;
		their_addr.sin_port = htons(PORT); /* short, NBO */
		their_addr.sin_addr = *((struct in_addr *)he->h_addr);
		bzero(&(their_addr.sin_zero), 8); /* 其余部分设成0 */
		numbytes = sendto(sockfd, buf, MAXDATASIZE, 0, (struct sockaddr *)&their_addr,sizeof(their_addr))；
		if (numbytes == -1) {
			perror(“sendto");
			exit(1);
		}
		printf(“Send: %s",buf);
		numbytes = recvfrom(sockfd, buf, MAXDATASIZE, 0, (struct sockaddr *)&their_addr, &sin_size);
		if (numbytes == -1) {
			perror("recvfrom");
			exit(1);
		}
		buf[numbytes] = '\0';
		printf("Received: %s",buf);
		close(sockfd);
		return 0;
	}