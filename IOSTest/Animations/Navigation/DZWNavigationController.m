//
//  DZWNavigationController.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWNavigationController.h"
#import "DZWNavigationInterTransition.h"

@interface DZWNavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIPanGestureRecognizer *popRecognizer;
/**
 *  方案一不需要的变量
 */
@property (nonatomic, strong) DZWNavigationInterTransition *navTransition;
@end

@implementation DZWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTransition = [[DZWNavigationInterTransition alloc] initWithViewController:self];
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self.navTransition action:@selector(handleControllerPop:)];
    popRecognizer.delegate = self;
    popRecognizer.maximumNumberOfTouches = 1;
    
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:popRecognizer];
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return self.viewControllers.count!=1&&![[self valueForKey:@"_isTransitioning"] boolValue];
}


@end
