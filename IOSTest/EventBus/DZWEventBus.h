//
//  DZWEventBus.h
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZWEventMessage.h"
#import "DZWEventID.h"
#import "DZWEventDataInfo.h"

@interface DZWEventBus : NSObject
+(instancetype)shareInstance;
-(void)register:(NSObject*)obj;
-(void)unregister:(NSObject*)obj;
-(void)publishEventMessage:(DZWEventMessage *)event;
-(void)publishEventMessage:(DZWEventMessage *)event withAction:(void (^)(DZWEventDataInfo * eventData))block;

@end
