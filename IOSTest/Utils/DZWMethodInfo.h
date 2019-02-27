//
//  DZWMethodInfo.h
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZWMethodInfo : NSObject
@property(assign,nonatomic)IMP imp;
@property(assign,nonatomic)SEL sel;
@property(copy,nonatomic)NSString* method_name;
@property(assign,nonatomic)int  method_arg_count;
@property(copy,nonatomic)NSString*  method_arg_encoding;

@end
