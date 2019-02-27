//
//  IMSocketManager.h
//  IOSTest
//
//  Created by milodeng on 2018/6/27.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IMSocketManager;
@protocol IMSocketManagerDelegate<NSObject>
//接收到数据
- (void)IMSocket:(IMSocketManager *)socket didReceiveMessage:(id)message;
//socket连接成功
- (void)IMSocketDidOpen:(IMSocketManager *)socket;
//socket连接失败
- (void)IMSocketdOpen:(IMSocketManager *)socket didFailWithError:(NSError *)error;
//socket心跳返回状态
- (void)IMSocket:(IMSocketManager *)socket didReceiveBeatHeart:(BOOL)isConnetBeat;
//socket网络关闭,
- (void)IMSocket:(IMSocketManager *)socket didCloseWithCode:(NSInteger)code reason:(NSString *)reason;
//接收数据超时
- (void)IMSocketTimeOut:(IMSocketManager *)socket;
@end

@interface IMSocketManager : NSObject
@property(weak,nonatomic)id<IMSocketManagerDelegate> delegate;

//连接socekt
-(void)connectSocket;
//简单重连机制
-(void)reconnectSocket;
//销毁socekt
-(void)destroySocket;
//添加队列
-(void)addOprationQuene:(NSOperationQueue*)queue;
//发送消息
- (void)sendMsg:(NSString *)msg;
//线程拉取消息
-(void)pullMesg;
//初始化心跳
- (void)initHeartBeat;
//取消心跳
- (void)destoryHeartBeat;

@end
