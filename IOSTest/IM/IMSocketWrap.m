//
//  IMSocketWrap.m
//  IOSTest
//
//  Created by milodeng on 2018/6/27.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "IMSocketWrap.h"
@interface IMSocketWrap()
@property(nonatomic,strong)IMSocketManager *socektManager;
@property(nonatomic,strong)NSOperationQueue *queue;
@end

@implementation IMSocketWrap
-(instancetype)init{
    self = [super init];
    if(self){
        _socektManager = [[IMSocketManager alloc] init];
        _socektManager.delegate = self;
        _queue =[[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
        [_socektManager addOprationQuene:_queue];
        [self connect];
    }
    return self;
}
-(void)dealloc{
    [_socektManager destroySocket];
}

-(void)connect{
    [_socektManager connectSocket];
}

#pragma mark --IMSocketManagerDelegate
-(void)IMSocketDidOpen:(IMSocketManager *)socket{
    //socket connect
    //1. 拉取消息 2.初始化新跳包，3发送消息
    [_socektManager pullMesg];
    [_socektManager initHeartBeat];
    [_socektManager sendMsg:@"hello world"];
}

-(void)IMSocketdOpen:(IMSocketManager *)socket didFailWithError:(NSError *)error{
    //connect fail
    [_socektManager reconnectSocket];
}
-(void)IMSocket:(IMSocketManager *)socket didReceiveMessage:(id)message{
    //dosomthing
}
-(void)IMSocket:(IMSocketManager *)socket didReceiveBeatHeart:(BOOL)isConnetBeat{
    //net ok
}
-(void)IMSocket:(IMSocketManager *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason{
    //network enable
    [_socektManager destoryHeartBeat];
}
-(void)IMSocketTimeOut:(IMSocketManager *)socket{
    //time out
}
@end
