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

## I/O模型 ##
### 阻塞I/O ###
简介：进程会一直阻塞，直到数据拷贝完成。

应用程序调用一个IO函数，导致应用程序阻塞，等待数据准备好。 如果数据没有准备好，一直等待….数据准备好了，从内核拷贝到用户空间,IO函数返回成功指示。

*即在调用recv()/recvfrom（）函数时，发生在内核中等待数据和复制数据的过程。*

![](http://my.csdn.net/uploads/201204/12/1334216532_9745.jpg)
### 非阻塞I/O ###
简介：非阻塞IO通过进程反复调用IO函数（多次系统调用，并马上返回）；在数据拷贝的过程中，进程是阻塞的；

我们把一个SOCKET接口设置为非阻塞就是告诉内核，当所请求的I/O操作无法完成时，不要将进程睡眠，而是返回一个错误。这样我们的I/O操作函数将不断的测试数据是否已经准备好，如果没有准备好，继续测试，直到数据准备好为止。在这个不断测试的过程中，会大量的占用CPU的时间。

![](http://my.csdn.net/uploads/201204/12/1334216607_3004.jpg)
### I/O复用 ###
简介：主要是select和epoll；对一个IO端口，两次调用，两次返回，比阻塞IO并没有什么优越性；关键是能实现同时对多个IO端口进行监听；

I/O复用模型会用到select、poll、epoll函数，这几个函数也会使进程阻塞，但是和阻塞I/O所不同的的，这两个函数可以同时阻塞多个I/O操作。而且可以同时对多个读操作，多个写操作的I/O函数进行检测，直到有数据可读或可写时，才真正调用I/O操作函数。

![](http://my.csdn.net/uploads/201204/12/1334216620_6310.jpg)
### 信号驱动I/O ###
简介：两次调用，两次返回；

首先我们允许套接口进行信号驱动I/O,并安装一个信号处理函数，进程继续运行并不阻塞。当数据准备好时，进程会收到一个SIGIO信号，可以在信号处理函数中调用I/O操作函数处理数据。

![](http://my.csdn.net/uploads/201204/12/1334216632_6025.jpg)
#### 异步I/O ####
简介：数据拷贝的时候进程无需阻塞。

当一个异步过程调用发出后，调用者不能立刻得到结果。实际处理这个调用的部件在完成后，通过状态、通知和回调来通知调用者的输入输出操作

![](http://my.csdn.net/uploads/201204/12/1334216641_7821.jpg)

### 5种I/O模型比较 ###

![](http://my.csdn.net/uploads/201204/12/1334216724_2405.jpg)


### select、poll、epoll对比介绍 ###

#### select ####
select本质上是通过设置或者检查存放fd标志位的数据结构来进行下一步处理。这样所带来的缺点是：

1、 单个进程可监视的fd数量被限制，即能监听端口的大小有限。
一般来说这个数目和系统内存关系很大，具体数目可以cat /proc/sys/fs/file-max察看。32位机默认是1024个。64位机默认是2048.

2、 对socket进行扫描时是线性扫描，即采用轮询的方法，效率较低：
当套接字比较多的时候，每次select()都要通过遍历FD_SETSIZE个Socket来完成调度,不管哪个Socket是活跃的,都遍历一遍。这会浪费很多CPU时间。如果能给套接字注册某个回调函数，当他们活跃时，自动完成相关操作，那就避免了轮询，这正是epoll与kqueue做的。

3、需要维护一个用来存放大量fd的数据结构，这样会使得用户空间和内核空间在传递该结构时复制开销大
#### poll ####
poll本质上和select没有区别，它将用户传入的数组拷贝到内核空间，然后查询每个fd对应的设备状态，如果设备就绪则在设备等待队列中加入一项并继续遍历，如果遍历完所有fd后没有发现就绪设备，则挂起当前进程，直到设备就绪或者主动超时，被唤醒后它又要再次遍历fd。这个过程经历了多次无谓的遍历。

它没有最大连接数的限制，原因是它是基于链表来存储的，但是同样有一个缺点：

1、大量的fd的数组被整体复制于用户态和内核地址空间之间，而不管这样的复制是不是有意义。
2、poll还有一个特点是“水平触发”，如果报告了fd后，没有被处理，那么下次poll时会再次报告该fd。
#### epoll ####
epoll支持水平触发和边缘触发，最大的特点在于边缘触发，它只告诉进程哪些fd刚刚变为就需态，并且只会通知一次。还有一个特点是，epoll使用“事件”的就绪通知方式，通过epoll_ctl注册fd，一旦该fd就绪，内核就会采用类似callback的回调机制来激活该fd，epoll_wait便可以收到通知
epoll的优点：
1、没有最大并发连接的限制，能打开的FD的上限远大于1024（1G的内存上能监听约10万个端口）；
2、效率提升，不是轮询的方式，不会随着FD数目的增加效率下降。只有活跃可用的FD才会调用callback函数；
即Epoll最大的优点就在于它只管你“活跃”的连接，而跟连接总数无关，因此在实际的网络环境中，Epoll的效率就会远远高于select和poll。
3、 内存拷贝，利用mmap()文件映射内存加速与内核空间的消息传递；即epoll使用mmap减少复制开销。

#### 区别总结 ####

1. 支持一个进程所能打开的最大连接数
select:FD_SETSIZE(32*32 or 32*64)
poll:基于链表存储，无上限
epoll:虽然连接数有上限，但是很大，1G内存的机器可以打开10W左右的连接

2. FD剧增后带来的I/O效率问题
select:因为每次调用时都会对连接进行线性遍历，所以随着FD的增加会造成遍历速度慢的“线性下降性能问题”。
poll:同上
epoll:因为epoll内核中实现是根据每个fd上的callback函数来实现的，只有活跃的socket才会主动调用callback，所以在活跃socket较少的情况下，使用epoll没有前面两者的线性下降的性能问题，但是所有socket都很活跃的情况下，可能会有性能问题。

3. 消息传递方式
select:内核需要将消息传递到用户空间，都需要内核拷贝动作
poll:同上
epoll:epoll通过内核和用户空间共享一块内存来实现的。

#### 总结 ####
综上，在选择select，poll，epoll时要根据具体的使用场合以及这三种方式的自身特点。
1. 表面上看epoll的性能最好，但是在连接数少并且连接都十分活跃的情况下，select和poll的性能可能比epoll好，毕竟epoll的通知机制需要很多函数回调。
2. select低效是因为每次它都需要轮询。但低效也是相对的，视情况而定，也可通过良好的设计改善


