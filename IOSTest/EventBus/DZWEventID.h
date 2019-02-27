//
//  DZWEventID.h
//  IOSTest
//
//  Created by limodeng on 2018/5/11.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZWEventMessage.h"
#import "DZWEventDataInfo.h"
#define  FETCHASYBLOCEDATA  @"fetchAsyBlockData"   //定义与 -(DZWEventDataInfo*)fetchAsyBlockData方法名称相同


@protocol DZWEventIDDelegate <NSObject>
@optional

/*
 *接收事件的定义约定为以OnReceive开头命名，约定为以Event结尾。
 */
-(void)OnReceiveLoadTestEvent:(DZWEventMessage*)event;

-(void)OnReceiveLoadAsyTestEvent:(DZWEventMessage*)event;


/*
 *异步线程执行完成后接收回调数据。
 */
-(DZWEventDataInfo*)fetchAsyBlockData;

@end

@interface DZWEventID : NSObject
@property (nonatomic,copy) NSString *eventName;

/*
 *事件ID的定义约定为以onEvent开头命名
*/
+(instancetype)onEventLoadTest;

+(instancetype)onEventLoadAsyTest;
@end
