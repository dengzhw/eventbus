//
//  DZWAsynOperation.m
//  IOSTest
//
//  Created by limodeng on 2018/8/23.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWAsynOperation.h"
typedef enum{
    OperationStateReadey = 1,
    OperationStateExecuting = 2,
    OperationStateFinished = 3
} OperationState;

@interface DZWAsynOperation()
@property(assign,nonatomic)OperationState state;
@end
@implementation DZWAsynOperation

-(instancetype)init{
    self = [super init];
    if(self){
        self.state = OperationStateReadey;
    }
    return self;
}
-(void)setState:(OperationState)state{
    switch (state) {
        case OperationStateReadey:
            [self willChangeValueForKey:@"isReady"];
            break;
            
        case OperationStateExecuting:
            [self willChangeValueForKey:@"isReady"];
            [self willChangeValueForKey:@"isExecuting"];
            break;
            
        case OperationStateFinished:
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            break;
    }
    _state=state;
    
    switch (state) {
        case OperationStateReadey:
            [self didChangeValueForKey:@"isReady"];
            break;
        case OperationStateExecuting:
            [self didChangeValueForKey:@"isReady"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
            
        case OperationStateFinished:
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            break;
            
    }
}
- (BOOL)isAsynchronous{
    return YES;
}
-(BOOL)isExecuting{
    return _state==OperationStateReadey;
}
-(BOOL)isFinished{
    return _state==OperationStateFinished;
}
-(BOOL)isReady{
    return _state==OperationStateReadey&&[super isReady];
}
-(void)start{
    if([self isCancelled]){
        self.state = OperationStateFinished;
    }else{
        self.state = OperationStateExecuting;
        [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    }
}
-(void)main{
    @try{
        @autoreleasepool{
            BOOL taskIsFinished = NO;
            // while 保证：只有当没有执行完成和没有被取消，才执行自定义的相应操作
            while (taskIsFinished == NO && [self isCancelled] == NO){
                // 自定义的操作
                NSLog(@"currentThread = %@", [NSThread currentThread]);
                NSLog(@"mainThread    = %@", [NSThread mainThread]);
                NSURL *URL = [NSURL URLWithString:self.url];
                NSData *data = [NSData dataWithContentsOfURL:URL];
                // 越晚执行越好，一般写在耗时操作后面(可以每行代码后面写一句)
                if([self isCancelled]){
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{//回到主线程，传递数据给代理对象
                    self.completBlock(data);
                });

                // 这里相应的操作都已经完成，后面就是要通知KVO我们的操作完成了。
                taskIsFinished = YES;
            }
            self.state = OperationStateFinished;
        }
        
    }
    @catch(NSException *e){
        self.state = OperationStateFinished;
    }
}

-(BOOL)executeOperation{
    BOOL  isExcuteSucess = NO;
    if ([self isReady] && ![self isCancelled]){
        if (![self isAsynchronous]) {
            [self start];
        }else {
            [NSThread detachNewThreadSelector:@selector(start)
                                     toTarget:self withObject:nil];
        }
        isExcuteSucess = YES;
    }
    else if ([self isCancelled]){
        self.state = OperationStateFinished;

        isExcuteSucess = YES;
    }
    return isExcuteSucess;

}
@end
