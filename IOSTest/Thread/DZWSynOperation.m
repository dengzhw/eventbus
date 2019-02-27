//
//  DZWSynOperation.m
//  IOSTest
//
//  Created by limodeng on 2018/8/23.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWSynOperation.h"
@interface DZWSynOperation()
@property(copy,nonatomic)NSString *url;
@property(copy,nonatomic) void(^completeBlock)(NSData *data);
@end

@implementation DZWSynOperation
-(instancetype)initWithUrl:(NSString*)url withBlock:(void(^)(NSData *data))successBlock{
    self = [super init];
    if(self){
        _url = url;
        _completeBlock = successBlock;
    }
    return self;
}
-(void)main{
    @try{
        @autoreleasepool{
            NSLog(@"threadBefore");
            BOOL taskIsFinished = NO;
            // 越晚执行越好，一般写在耗时操作后面(可以每行代码后面写一句)
            if([self isCancelled]){
                return;
            }
            while (taskIsFinished==NO&&[self isCancelled]==NO) {
                NSURL *URL = [NSURL URLWithString:self.url];
                NSData *data = [NSData dataWithContentsOfURL:URL];
                sleep(2);  // 睡眠模拟耗时操作
                NSLog(@"currentThread = %@", [NSThread currentThread]);
                NSLog(@"mainThread    = %@", [NSThread mainThread]);
                // 越晚执行越好，一般写在耗时操作后面(可以每行代码后面写一句)
                if([self isCancelled]){
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{//回到主线程，传递数据给代理对象
                    self.completeBlock(data);
                });

                taskIsFinished = YES;
            }
            NSLog(@"threadAfter");
        }
        
    }
    @catch(NSException*e){
        NSLog(@"exception:%@",e);
    }

}
@end
