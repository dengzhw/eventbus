//
//  DZWDissmissAnimation.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWDissmissAnimation.h"

@implementation DZWDissmissAnimation
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    /*
     *获取转场动画来自哪个控制器
     */
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    /*
     *转场动画是两个控制器视图时间的动画，需要一个containerView来作为导演，让动画执行
     */
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];

    CGRect rect =   [UIScreen mainScreen].bounds;
    fromViewController.view.frame = rect;
    /**
     *  执行动画，我们让fromVC的视图移动到屏幕最右侧
     */
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.frame = CGRectMake(rect.size.width, 0, rect.size.width, rect.size.height);
    }completion:^(BOOL finished) {
        /**
         *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
         */
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];

    }];
}
@end
