//
//  DZWEventIDPool.m
//  IOSTest
//
//  Created by limodeng on 2018/5/11.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWEventIDPool.h"
#import "DZWEventID.h"

@interface DZWEventIDPool()
@property (nonatomic,strong) NSMutableDictionary<NSString *,DZWEventID *> *eventMap;
@end
@implementation DZWEventIDPool

+ (instancetype)sharedInstance{
    static DZWEventIDPool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype) init{
    
    if(self = [super init]){
        _eventMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addEventID:(DZWEventID *)event{
    [self.eventMap setValue:event forKey:event.eventName];
}

- (DZWEventID *)getEventID:(NSString *)name{
    return [self.eventMap objectForKey:name];
}
@end
