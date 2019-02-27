//
//  DZWEventMessage.h
//  IOSTest
//
//  Created by limodeng on 2018/5/9.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#define EVENTPREFIX @"OnReceive"
#define EVENTSuFFIX @"Event"

typedef enum{
    OnMainThread        = 0,    /**< 主线程    */
    PriorityHight     = 1,   /**< 异步线程高优先级    */
    PriorityNarmal    = 2,   /**< 异步线程普通先级    */
    PriorityLow       = 3,   /**< 异步线程低先级   */

}EventOnRunThread;

@interface DZWEventMessage : NSObject<NSCopying>
@property(copy,nonatomic)NSString*eventName;
@property(assign,nonatomic)NSInteger what;
@property(strong,nonatomic)NSObject *obj;
@property(assign,nonatomic)EventOnRunThread runOnThread;
@end
