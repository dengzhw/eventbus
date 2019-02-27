//
//  DZWAsynOperation.h
//  IOSTest
//
//  Created by limodeng on 2018/8/23.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZWAsynOperation : NSOperation
@property(copy,nonatomic)NSString* url;
@property(copy,nonatomic) void(^completBlock)(NSData* data);

-(BOOL)executeOperation;

@end
