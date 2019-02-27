//
//  DZWPopAnimation.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWPopAnimation.h"
@interface DZWPopAnimation()
@property(strong,nonatomic) id <UIViewControllerContextTransitioning> transitionContext;
@end

@implementation DZWPopAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    /*
     *获取转场动画来自哪个控制器
     */
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    /*
     *获取转场到哪个控制器
     */
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /*
     *转场动画是两个控制器视图时间的动画，需要一个containerView来作为导演，让动画执行
     */
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    /**
     *  执行动画，我们让fromVC的视图移动到屏幕最右侧
     */
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
    }completion:^(BOOL finished) {
        /**
         *  当你的动画执行完成，这个方法必须要调用，否则系统会认为你的其余任何操作都在动画执行过程中。
         */
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
    self.transitionContext = transitionContext;
    
}

- (void)animationDidStop:(CATransition *)anim finished:(BOOL)flag {
    [_transitionContext completeTransition:!_transitionContext.transitionWasCancelled];
}

@end
