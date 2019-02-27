//
//  DZWEventBus.m
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWEventBus.h"
#import "NSObject+runtime.h"


@interface DZWEventBus()
@property(strong,nonatomic)NSMutableDictionary *hashMap;
@property(strong,nonatomic)NSOperationQueue *operationQueue;
@end;
@implementation DZWEventBus
+(instancetype)shareInstance{
    static DZWEventBus  *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DZWEventBus alloc] init];
    });
    return instance;
}
-(instancetype)init{
    self = [super init];
    if(self){
        _hashMap = [NSMutableDictionary dictionary];
        _operationQueue=[[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:1];
    }
    return self;
}
-(void)register:(NSObject*)obj{
    if(!obj){
        return;
    }
    NSString *className = NSStringFromClass([obj class]);
    if(![self.hashMap objectForKey:className]){
       
        [self.hashMap setObject:obj forKey:className];
    }
}

-(void)unregister:(NSObject*)obj{
    if(obj){
        NSString *className = NSStringFromClass([obj class]);
        [self.hashMap removeObjectForKey:className];
    }
}
//第一个参数是消息体,所有事件都在主线程中完成。
-(void)publishEventMessage:(DZWEventMessage *)event{
    for (NSString *key in self.hashMap.allKeys) {
        NSObject *object = [self.hashMap objectForKey:key];
        NSString *eventBody = event.eventName;
        NSString *eventAllName = [NSString stringWithFormat:@"%@%@%@:",EVENTPREFIX,eventBody,EVENTSuFFIX];
        SEL eventSelector = NSSelectorFromString(eventAllName);
        if([object respondsToSelector:eventSelector]){
            Method method = class_getInstanceMethod([object class],eventSelector);
            IMP imp = method_getImplementation(method);
            //执行方法
            ((void(*)(id, SEL,id))imp)(object, eventSelector,event);
        }
    }

}

//第一个参数是消息体,所有事件都在异步线程中完成。
-(void)publishEventMessage:(DZWEventMessage *)event withAction:(void (^)(DZWEventDataInfo * eventData))block{
    if(event.runOnThread==OnMainThread){
        [self publishEventMessage:event];
        return ;
    }
    for (NSString *key in self.hashMap.allKeys) {
        NSString *objKey = [key copy];
        NSLog(@"What信息:%@",@(event.what));
        NSBlockOperation *opBlock = [NSBlockOperation blockOperationWithBlock:^{
            [self asyExcutePublishEventMessage:[event copy] withKey:objKey withAction:^(DZWEventDataInfo *eventData) {
                block(eventData);
            }];
        }];
        if(event.runOnThread==PriorityHight){
            opBlock.queuePriority =  NSQualityOfServiceUserInteractive;
            NSLog(@"高优先级");

        }else if(event.runOnThread==PriorityNarmal){
            opBlock.queuePriority =  NSQualityOfServiceUserInitiated;
            NSLog(@"普通先级");

        }else if(event.runOnThread==PriorityLow){
            opBlock.queuePriority =  NSQualityOfServiceBackground;
            NSLog(@"低先级");

        }
        [_operationQueue addOperations:@[opBlock] waitUntilFinished:NO];
    }
    
}

-(void)asyExcutePublishEventMessage:(DZWEventMessage *)eventMsg withKey:(NSString*)key withAction:(void (^)(DZWEventDataInfo * eventData))block{
    DZWEventMessage * event = [eventMsg copy];
    NSObject *object = [self.hashMap objectForKey:key];
    NSString *eventBody = event.eventName;
    NSString *eventAllName = [NSString stringWithFormat:@"%@%@%@:",EVENTPREFIX,eventBody,EVENTSuFFIX];

    SEL eventSelector = NSSelectorFromString(eventAllName);
    if([object respondsToSelector:eventSelector]){
        Method method = class_getInstanceMethod([object class],eventSelector);
        IMP imp = method_getImplementation(method);
        //执行方法
//        NSLog(@"beginTime:%@",[self currentTimeStr]);
        ((void(*)(id, SEL,id))imp)(object, eventSelector,event);
        SEL blockSelector = NSSelectorFromString(FETCHASYBLOCEDATA);
        if([object respondsToSelector:blockSelector]){
            Method blockMethod = class_getInstanceMethod([object class],blockSelector);
            IMP blockImp = method_getImplementation(blockMethod);
            //执行方法
            DZWEventDataInfo *blockData = ((id(*)(id, SEL))blockImp)(object, blockSelector);
            //                NSLog(@"endTime:%@",[self currentTimeStr]);
            if(block&&blockData){
                block(blockData);
            }else{
                block(nil);
            }
        }else{
            NSLog(@"%@没有实现fetchAsyBlockData方法",NSStringFromClass([object class]));
            block(nil);
        }
       
    }
}

//获取当前时间戳
- (NSString *)currentTimeStr{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];//获取当前时间0秒后的时间
    NSTimeInterval time=[date timeIntervalSince1970]*1000;// *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}
@end
