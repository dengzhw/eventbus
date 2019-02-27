//
//  DZWMenuCell.m
//  IOSTest
//
//  Created by limodeng on 2018/6/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWMenuCell.h"
@interface DZWMenuCell()
@property(strong,nonatomic)UILabel *titleLB;
@end

@implementation DZWMenuCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor grayColor];
        self.contentView.backgroundColor = [UIColor grayColor];
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [self addSubview:self.titleLB];
}
-(UILabel*)titleLB{
    if(!_titleLB){
        _titleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLB.textColor = [UIColor blackColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLB;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLB.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
-(void)refreshCellWithTitle:(NSString*)title withIsCurrentIndex:(BOOL)isCurrent{
    if(isCurrent){
        self.titleLB.font = [UIFont systemFontOfSize:22];
        self.titleLB.textColor = [UIColor redColor];
    }else{
        self.titleLB.font = [UIFont systemFontOfSize:14];
        self.titleLB.textColor = [UIColor blackColor];
    }
    self.titleLB.text = title;
}
@end
