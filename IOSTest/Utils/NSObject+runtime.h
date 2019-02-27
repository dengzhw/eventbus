//
//  NSObject+runtime.h
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "DZWMethodInfo.h"

@interface NSObject (runtime)
//获取类的所有属性
+(NSArray *)getAllProperties;
//获取类的所有方法列表
+(NSArray <DZWMethodInfo*>*)getAllMethods;
//获取类的所有属性和值
+ (NSDictionary *)getAllPropertiesAndVaules:(NSObject *)obj;



@end
