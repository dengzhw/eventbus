//
//  DZWEventID.m
//  IOSTest
//
//  Created by limodeng on 2018/5/11.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWEventID.h"
#import <objc/runtime.h>
#import "DZWEventIDPool.h"

#define EVENTIDPREFIX @"onEvent"

//去掉警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation DZWEventID

#pragma mark -动态添加静态方法实现相关代码

+ (BOOL) resolveClassMethod:(SEL)sel{
    NSString *selName = NSStringFromSelector(sel);
    if([selName hasPrefix:EVENTIDPREFIX]){
        class_addMethod(object_getClass(self), sel, (IMP)EventInit, "@@:");
        return YES;
    }
    return [super resolveClassMethod:sel];
}
static id EventInit(id self,SEL _cmd){
    NSString *selName = NSStringFromSelector(_cmd);
    if([selName hasPrefix:EVENTIDPREFIX]){
        selName = [selName substringFromIndex:[EVENTIDPREFIX length]];
    }
    return [DZWEventID eventWithName:selName];
}
#pragma mark -对象初始化相关代码

- (instancetype) initWithName:(NSString *)aName{
    if(self = [super init]){
        self.eventName = aName;
    }
    return self;
}
+ (instancetype) eventWithName:(nonnull NSString *)name{
    DZWEventID *eventID = [[DZWEventIDPool sharedInstance] getEventID:name];
    if(!eventID){
        eventID = [[DZWEventID alloc] initWithName:name];
        [[DZWEventIDPool sharedInstance] addEventID:eventID];
    }
    return eventID;
}
@end
