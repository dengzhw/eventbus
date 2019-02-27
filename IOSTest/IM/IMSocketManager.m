//
//  IMSocketManager.m
//  IOSTest
//
//  Created by milodeng on 2018/6/27.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "IMSocketManager.h"
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define kServerIPAddress  @"127.0.0.1" //服务器Ip
#define kServerPort 9999               //服务器端口

#define kReceiveMaxLen 1024
#define kSocketTimeOut 5
#define kRetryMaxCount 64


@interface IMSocketManager()
@property (nonatomic,assign)int clientSocket;
@property (nonatomic,assign)NSInteger retryCount;
@property (nonatomic,assign)NSTimer *heartBeat;
@property (nonatomic,strong)NSOperationQueue *operationQueue;
@property (nonatomic,assign)BOOL isAcive;

@end;

@implementation IMSocketManager

-(void)initSocekt{
    if(self.clientSocket!=0){
        [self disConnectSocket];
        self.clientSocket = 0;
    }
    self.isAcive = YES;
    self.clientSocket = [self createClientSocket];
    //服务器Ip
    const char * server_ip=[kServerIPAddress UTF8String];
    //服务器端口
    short server_port=kServerPort;
    //等于0说明连接失败
    if (ConnectionToServer(_clientSocket,server_ip, server_port)==-1) {
        NSLog(@"Connect to server error\n");
        dispatch_main_async_safe(^{
            if ([self.delegate respondsToSelector:@selector(IMSocketdOpen:didFailWithError:)]) {
                [self.delegate IMSocketdOpen:self didFailWithError:nil];
            }
        });
        return ;
    }
    //走到这说明连接成功
    NSLog(@"Connect to server ok\n");
    dispatch_main_async_safe(^{
        if ([self.delegate respondsToSelector:@selector(IMSocketDidOpen:)]) {
            [self.delegate IMSocketDidOpen:self];
        }
    });
    
    
}
-(int)createClientSocket{
    int ClinetSocket = 0;
    //创建一个socket,返回值为Int。（注scoket其实就是Int类型）
    //第一个参数addressFamily IPv4(AF_INET) 或 IPv6(AF_INET6)。
    //第二个参数 type 表示 socket 的类型，通常是流stream(SOCK_STREAM) 或数据报文datagram(SOCK_DGRAM)
    //第三个参数 protocol 参数通常设置为0，以便让系统自动为选择我们合适的协议，对于 stream socket 来说会是 TCP 协议(IPPROTO_TCP)，而对于 datagram来说会是 UDP 协议(IPPROTO_UDP)。
    ClinetSocket = socket(AF_INET, SOCK_STREAM, 0);
    return ClinetSocket;
}

static int ConnectionToServer(int client_socket,const char * server_ip,unsigned short port)
{
    
    //生成一个sockaddr_in类型结构体
    struct sockaddr_in serveraAddr;
    /* 给本地的socket地址赋值 */
    memset(&serveraAddr,0,sizeof(struct sockaddr_in));
    //设置IPv4
    serveraAddr.sin_family = AF_INET;
    //inet_aton是一个改进的方法来将一个字符串IP地址转换为一个32位的网络序列IP地址
    //如果这个函数成功，函数的返回值非零，如果输入地址不正确则会返回零。
    serveraAddr.sin_addr.s_addr = inet_addr(server_ip);
    //htons是将整型变量从主机字节顺序转变成网络字节顺序，赋值端口号
    serveraAddr.sin_port = htons(port);
    
    //设置socket发送超时时间和接收超时时间
    struct timeval timeout={kSocketTimeOut,0};//5s
    int ret=setsockopt(client_socket,SOL_SOCKET,SO_SNDTIMEO,(const char*)&timeout,sizeof(timeout));
    if(ret == -1){
        NSLog(@"创建失败");
        return -1;
    }
    int ret1=setsockopt(client_socket,SOL_SOCKET,SO_RCVTIMEO,(const char*)&timeout,sizeof(timeout));
    if(ret1==-1){
        NSLog(@"创建失败");
        return -1;
    }
    //用scoket和服务端地址，发起连接。
    //客户端向特定网络地址的服务器发送连接请求，连接成功返回0，失败返回 -1。
    //注意：该接口调用会阻塞当前线程，直到服务器返回。
    int res = connect(client_socket, (struct sockaddr *)&serveraAddr, sizeof(serveraAddr));
    if (res==0) {
        return client_socket;
    }
    return -1;
}

//收取服务端发送的消息
- (void)recieveAction{
    while (_isAcive){
        char recv_Message[kReceiveMaxLen] = {0};
        int receResult =  (int)recv(_clientSocket, recv_Message, sizeof(recv_Message), 0);
        //errno==EAGAIN  这里可以做更多的错误处理
        if(receResult==-1&&errno==EAGAIN){
            NSLog(@"timeout\n");
            dispatch_main_async_safe(^{
                if ([self.delegate respondsToSelector:@selector(IMSocketTimeOut:)]) {
                    [self.delegate IMSocketTimeOut:self];
                }
            });
        }else{
            if(receResult<0){
                NSLog(@"服务器错误\n");
            }else{
                NSString *dataString = [NSString stringWithUTF8String:recv_Message];
                //心跳包返回数据,与后台服务器定的标识
                if([dataString isEqualToString:@"hb"]){
                    dispatch_main_async_safe(^{
                        self.retryCount = 0;
                        if ([self.delegate respondsToSelector:@selector(IMSocket:didReceiveBeatHeart:)]) {
                            [self.delegate IMSocket:self didReceiveBeatHeart:YES];
                        }
                    });
                }else{
                    //接收到数据
                    if([dataString isEqualToString:@"hb"]){
                        dispatch_main_async_safe(^{
                            if ([self.delegate respondsToSelector:@selector(IMSocket:didReceiveMessage:)]) {
                                [self.delegate IMSocket:self didReceiveMessage:dataString];
                            }
                        });
                    NSLog(@"%@\n",[NSString stringWithUTF8String:recv_Message]);
                }
            }
        }
       
    }
 }
}

//关闭socekt
-(void)disConnectSocket{
    close(self.clientSocket);
    self.clientSocket = 0;
}

#pragma mark --对外暴露的方法
//连接socekt
-(void)connectSocket{
    _retryCount = 0;
    [self initSocekt];
}
//简单重连机制
-(void)reconnectSocket{
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (_retryCount > 64) {
        dispatch_main_async_safe(^{
            if ([self.delegate respondsToSelector:@selector(IMSocket:didCloseWithCode:reason:)]) {
                [self.delegate IMSocket:self didCloseWithCode:-1 reason:nil];
            }
        });
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_retryCount * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self initSocekt];
    });
    
    //重连时间2的指数级增长
    if (_retryCount == 0) {
        _retryCount = 2;
    }else{
        _retryCount *= 2;
    }
}


-(void)destroySocket{
    [self disConnectSocket];
    _isAcive = NO;
}

//发送消息
- (void)sendMsg:(NSString *)msg{
    const char *send_Message = [msg UTF8String];
    send(self.clientSocket,send_Message,strlen(send_Message)+1,0);
}
//线程拉取消息
-(void)pullMesg{
    if(self.clientSocket){
        __weak typeof(IMSocketManager) *weakself = self;
        [self.operationQueue addOperationWithBlock:^{
            [weakself recieveAction];
        }];
    }
}
//添加队列
-(void)addOprationQuene:(NSOperationQueue*)queue{
    _operationQueue = queue;
}

//初始化心跳
- (void)initHeartBeat{
    dispatch_main_async_safe(^{
        [self destoryHeartBeat];
        //心跳设置为3分钟，NAT超时一般为5分钟
        self.heartBeat = [NSTimer scheduledTimerWithTimeInterval:3*60 target:self selector:@selector(heartBeatAction) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:_heartBeat forMode:NSRunLoopCommonModes];
    })
}
//心跳发送探测消息
-(void)heartBeatAction{
    NSLog(@"heart");
    //和服务端约定好发送什么作为心跳标识，尽可能的减小心跳包大小
    if(self.clientSocket&&self.operationQueue){
        [self sendMsg:@"heart"];
    }
}

//取消心跳
- (void)destoryHeartBeat{
    _isAcive = NO;
    dispatch_main_async_safe(^{
        if (_heartBeat) {
            [_heartBeat invalidate];
            _heartBeat = nil;
        }
    })
}


@end
