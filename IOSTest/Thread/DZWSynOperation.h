//
//  DZWSynOperation.h
//  IOSTest
//
//  Created by limodeng on 2018/8/23.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZWSynOperation : NSOperation
-(instancetype)initWithUrl:(NSString*)url withBlock:(void(^)(NSData *data))successBlock;

@end
