//
//  DZWHomeViewController.m
//  IOSTest
//
//  Created by limodeng on 2018/6/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWHomeViewController.h"
#import "DZWMenuView.h"

@interface DZWHomeViewController ()
@property(strong,nonatomic)NSArray<NSString*>*itemList;
@property(strong,nonatomic)DZWMenuView *horMenuView;
@end

@implementation DZWHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupData];
    [self setupView];
}

-(void)setupData{
    self.itemList = @[@"精选",@"电影",@"体育",@"电视剧",@"综艺",@"少儿",@"动漫",@"纪录片",@"创造101",@"王者荣耀",@"VIP会员",@"美剧",@"杜比",@"斗罗大陆",@"精选",@"电影",@"体育",@"电视剧",@"综艺",@"少儿",@"动漫",@"纪录片",@"创造101",@"王者荣耀",@"VIP会员",@"美剧",@"杜比",@"斗罗大陆"];
}
-(void)setupView{
    [self.view addSubview:self.horMenuView];
}
-(DZWMenuView*)horMenuView{
    if(!_horMenuView){
        _horMenuView = [[DZWMenuView alloc] initWithFrame:CGRectZero];
        _horMenuView.backgroundColor =  [UIColor whiteColor];
        [_horMenuView addDataSource:_itemList];
    }
    return _horMenuView;
}


-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.horMenuView.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
