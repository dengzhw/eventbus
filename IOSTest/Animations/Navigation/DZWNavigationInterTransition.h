//
//  DZWNavigationInterTransition.h
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DZWNavigationInterTransition : NSObject<UINavigationControllerDelegate>

-(instancetype)initWithViewController:(UIViewController*)controller;

-(void)handleControllerPop:(UIPanGestureRecognizer*)recognizer;

- (UIPercentDrivenInteractiveTransition *)interPopTransition;

@end
