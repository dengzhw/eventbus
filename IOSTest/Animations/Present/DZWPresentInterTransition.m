//
//  DZWPresentInterTransition.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWPresentInterTransition.h"
#import "DZWPresentAnimation.h"
#import "DZWDissmissAnimation.h"


@implementation DZWPresentInterTransition

-(instancetype)initWithViewController:(UIViewController*)vc{
    self = [super init];
    if(self){
        vc.transitioningDelegate = self;
    }
    return self;
}
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[DZWPresentAnimation alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [[DZWDissmissAnimation alloc] init];
}

@end
