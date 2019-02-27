//
//  DZWEventMessage.m
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWEventMessage.h"

@implementation DZWEventMessage
- (NSString *)description {
    return [NSString stringWithFormat:@"address: %p, name: %@, number: %@", self, self.eventName, self.obj];
}

- (id)copyWithZone:(NSZone *)zone {
    DZWEventMessage *cpy = [[[self class] allocWithZone:zone] init];
    cpy.eventName = self.eventName;
    cpy.what = self.what;
    cpy.obj = self.obj;
    cpy.runOnThread = self.runOnThread;
    return cpy;
}
@end
