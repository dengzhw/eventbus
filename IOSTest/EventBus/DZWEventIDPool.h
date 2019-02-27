//
//  DZWEventIDPool.h
//  IOSTest
//
//  Created by limodeng on 2018/5/11.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DZWEventID;

@interface DZWEventIDPool : NSObject

+ (instancetype)sharedInstance;
- (void)addEventID:(DZWEventID *)event;
- (DZWEventID *)getEventID:(NSString *)name;

@end
