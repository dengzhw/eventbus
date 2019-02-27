//
//  DZWNavigationInterTransition.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWNavigationInterTransition.h"
#import "DZWPopAnimation.h"

@interface DZWNavigationInterTransition()
@property(nonatomic,weak)UINavigationController *navViewController;
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interPopTransition;
@end

@implementation DZWNavigationInterTransition

-(instancetype)initWithViewController:(UIViewController*)controller{
    self = [super init];
    if(self){
        self.navViewController= (UINavigationController*)controller;
        self.navViewController.delegate = self;
    }
    return self;
}
-(void)handleControllerPop:(UIPanGestureRecognizer*)recognizer{
    /**
     *  interactivePopTransition就是我们说的方法2返回的对象，我们需要更新它的进度来控制Pop动画的流程，我们用手指在视图中的位置与视图宽度比例作为它的进度。
     */
    CGFloat progress = [recognizer translationInView:recognizer.view].x / recognizer.view.bounds.size.width;
    /**
     *  稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
     */
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        /**
         *  手势开始，新建一个监控对象
         */
        self.interPopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        /**
         *  告诉控制器开始执行pop的动画
         */
        [self.navViewController popViewControllerAnimated:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        /**
         *  更新手势的完成进度
         */
        [self.interPopTransition updateInteractiveTransition:progress];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        /**
         *  手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过。
         */
        if (progress > 0.5) {
            [self.interPopTransition finishInteractiveTransition];
        }
        else {
            [self.interPopTransition cancelInteractiveTransition];
        }
        
        self.interPopTransition = nil;
    }

}


#pragma mark --UINavigationControllerDelegate
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController NS_AVAILABLE_IOS(7_0){
    if([animationController isKindOfClass:[DZWPopAnimation class]]){
        return self.interPopTransition;
    }
    return nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  NS_AVAILABLE_IOS(7_0){
    if(operation==UINavigationControllerOperationPop){
        return [[DZWPopAnimation alloc] init];
    }
    return nil;
    
}
@end
