//
//  ViewController.m
//  IOSTest
//
//  Created by limodeng on 2018/5/7.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "NSObject+runtime.h"
#import "DZWHomeViewController.h"
#import "IMSocketWrap.h"
#import "Sort.h"
#import "DZWAsynOperation.h"
#import "DZWSynOperation.h"
#import "BinaryTreeNode.h"

@interface ViewController ()
@property(strong,nonatomic) UIViewController *vc;
@property(strong,nonatomic) NSMutableArray *array;
@end
@interface ViewController()
@property(copy,nonatomic) NSString *subtitle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *addVC = [UIButton buttonWithType:UIButtonTypeCustom];
    addVC.frame = CGRectMake(10, 200, 80, 40);
    [addVC setTitle:@"添加" forState:UIControlStateNormal];
    [addVC setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addVC addTarget:self action:@selector(IMAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addVC];
    [[DZWEventBus shareInstance] register:self];
    Sort *sort = [[Sort alloc] init];
    [sort quickSort];
    [sort bubSort];
    [sort insertSort];
    [sort heapSort];
    [BinaryTreeNode BinaryTreeNodeTest];

    NSLog(@"title%@",self.subtitle);
    [self operation];
    [self operation1];
//    [self invocationTest];
  
}
-(void)operation1{
    DZWSynOperation *op = [[DZWSynOperation alloc] initWithUrl:@"https://www.baidu.com/" withBlock:^(NSData *data) {
        NSLog(@"非并行ImageData:%@",data);
    }];
    [op start];
}

-(void)operation{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = 10;
    DZWAsynOperation *op1 = [[DZWAsynOperation alloc] init];
    op1.url = @"https://www.baidu.com/";
    op1.completBlock =^(NSData *imageData){
        NSLog(@"并行ImageData:%@",imageData);
    };
    DZWAsynOperation *op2 = [[DZWAsynOperation alloc] init];
    op2.url = @"https://www.baidu.com/";
    op2.completBlock =^(NSData *imageData){
        NSLog(@"并行ImageData:%@",imageData);
    };
    DZWAsynOperation *op3 = [[DZWAsynOperation alloc] init];
    op3.url = @"https://www.baidu.com/";
    op3.completBlock =^(NSData *imageData){
        NSLog(@"并行ImageData:%@",imageData);
    };
    [queue addOperations:@[op1,op2,op3] waitUntilFinished:NO];
}

/*
 在 iOS中可以直接调用某个对象的消息方式有两种：
 一种是 performSelector:withObject；
 再一种就是 NSInvocation。
 第一种方式比较简单，能完成简单的调用。但是对于 >2 个的参数或者有返回值的处理，那就需要做些额外工作才能搞定。那么在这种情况下，我们就可以使用NSInvocation来进行这些相对复杂的操作。
*/

-(void)invocationTest{
    NSMethodSignature *signature=[[self class] instanceMethodSignatureForSelector:@selector(handlerMessageWithIndex:withMessage:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = @selector(handlerMessageWithIndex:withMessage:);
    NSInteger index = 111;
    // 参数的0和1被target和sel占用了
    [invocation setArgument:&index atIndex:2];
    NSString *message = @"hello oc";
    [invocation setArgument:&message atIndex:3];
    [invocation invoke];
    
}

-(void)handlerMessageWithIndex:(NSInteger)index withMessage:(NSString*)message{
    NSLog(@"index:%@,message:%@",@(index),message);
}
-(void)OnReceiveLoadTestEvent:(DZWEventMessage *)event{
    
}
-(void)OnReceiveLoadAsyTestEvent:(DZWEventMessage*)event{
    if(event.runOnThread==OnMainThread){
        self.array = [[NSMutableArray alloc] init];
        for (NSInteger index = 0; index<10; index++) {
            [self.array addObject:@(index)];
            [NSThread sleepForTimeInterval:0.1];
        }
    }else{
        self.array = [[NSMutableArray alloc] init];
        for (NSInteger index = 100; index<110; index++) {
            [self.array addObject:@(index)];
            [NSThread sleepForTimeInterval:0.1];
        }
    }

}

-(DZWEventDataInfo*)fetchAsyBlockData{
    DZWEventDataInfo *dataInfo = [[DZWEventDataInfo alloc] init];
    if(self.array.count){
        dataInfo.dicData = @{@"dataKey":[self.array copy]};
        return dataInfo;
    }
    return nil;
}

-(void)dealloc{
    [[DZWEventBus shareInstance] unregister:self];

}
-(void)doAction:(NSString*)url withData:(NSString*)data{
    NSLog((@"hahahaha"));
}

-(void)presentAction{
    ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
    [self presentViewController:thirdVC animated:YES completion:nil];
}

-(void)pushAction{
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

-(void)IMAction:(id)sender{
    IMSocketWrap *socket = [[IMSocketWrap alloc] init];
}


//-(void)addViewController{
//    self.vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
//    [self addChildViewController:self.vc];
//    [self.view addSubview:self.vc.view];
//    self.vc.view.backgroundColor = [UIColor whiteColor];
//    self.vc.view.frame = self.view.bounds;
//    [self createView];
//    [self.vc didMoveToParentViewController:self];
//}
//
//-(void)createView{
//    UIButton *addVC = [UIButton buttonWithType:UIButtonTypeCustom];
//    addVC.frame = CGRectMake(10, 10, 80, 40);
//    [addVC setTitle:@"移除" forState:UIControlStateNormal];
//    [addVC setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [addVC addTarget:self action:@selector(removeViewController) forControlEvents:UIControlEventTouchUpInside];
//    [self.vc.view addSubview:addVC];
//}
//
//-(void)removeViewController{
//    [self.vc willMoveToParentViewController:nil];
//    [self.vc.view removeFromSuperview];
//    [self.vc removeFromParentViewController];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
