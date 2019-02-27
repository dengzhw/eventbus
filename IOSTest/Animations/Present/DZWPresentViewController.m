//
//  DZWPresentViewController.m
//  IOSTest
//
//  Created by limodeng on 2018/5/8.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWPresentViewController.h"
#import "DZWPresentInterTransition.h"

@interface DZWPresentViewController()
@property(strong,nonatomic)DZWPresentInterTransition *presentTransition;
@end

@implementation DZWPresentViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.presentTransition = [[DZWPresentInterTransition alloc] initWithViewController:self];
    
}
@end
