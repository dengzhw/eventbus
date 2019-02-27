//
//  ThirdViewController.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "ThirdViewController.h"
#import "DZWEventBus.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    UIButton *addVC = [UIButton buttonWithType:UIButtonTypeCustom];
    addVC.frame = CGRectMake(10, 200, 80, 40);
    [addVC setTitle:@"Dissmiss" forState:UIControlStateNormal];
    [addVC setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addVC addTarget:self action:@selector(presentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addVC];
}
-(void)presentAction{
    DZWEventMessage * event=[[DZWEventMessage alloc] init];
    event.eventName =[[DZWEventID onEventLoadTest] eventName];
    event.what = 1;
    event.obj = @"这是一个测试";
    
    [[DZWEventBus shareInstance] publishEventMessage:event];
    
    DZWEventMessage * asyEvent=[[DZWEventMessage alloc] init];
    asyEvent.eventName =[[DZWEventID onEventLoadAsyTest] eventName];
    asyEvent.runOnThread = PriorityHight;
    event.what = 1;
    asyEvent.obj = @"这是一个异步测试";
    
    for (NSInteger index = 0;index<10;index++) {
        NSInteger model = (arc4random()%3)+1;
        asyEvent.what = index;
        asyEvent.runOnThread = (EventOnRunThread)model;
        [[DZWEventBus shareInstance] publishEventMessage:asyEvent withAction:^(DZWEventDataInfo *eventData) {
            NSLog(@"优先级:");
        }];
    }
}

-(void)dismissAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
