//
//  DZWEventDataInfo.h
//  IOSTest
//
//  Created by limodeng on 2018/5/11.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZWEventMessage.h"

@interface DZWEventDataInfo : NSObject
@property(strong,nonatomic)NSDictionary *dicData;
@property(strong,nonatomic)DZWEventMessage *eventInfo;
@end
