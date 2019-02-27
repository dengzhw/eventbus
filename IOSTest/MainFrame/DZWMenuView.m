//
//  DZWMenuView.m
//  IOSTest
//
//  Created by limodeng on 2018/6/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "DZWMenuView.h"
#import "DZWMenuCell.h"
@interface DZWMenuView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSArray<NSString*>*menuDataSource;
@property(assign,nonatomic)NSInteger currentItemIndex;
@property(assign,nonatomic)NSInteger lastItemIndex;
@end;

static NSString *CellIdentifier = @"QNBMenuIdentify";
static NSInteger kscrollCount = 6;

@implementation DZWMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _currentItemIndex=0;
        _lastItemIndex = 0;
        [self setupView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

-(void)setupView{
    [self addSubview:self.collectionView];
}
-(UICollectionView*)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[DZWMenuCell class] forCellWithReuseIdentifier:CellIdentifier];
    }
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuDataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DZWMenuCell *cell = (DZWMenuCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell refreshCellWithTitle:[self.menuDataSource objectAtIndex:indexPath.row] withIsCurrentIndex:self.currentItemIndex==indexPath.row];
    return cell;
}
//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentItemIndex = indexPath.row;
    [self scrollAction:indexPath];
    [self.collectionView reloadData];
    self.lastItemIndex = self.currentItemIndex;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat fontSize = 14;
    if(self.currentItemIndex==indexPath.row){
        fontSize = 22;
    }
    CGFloat width = [self getWidthWithText:[self.menuDataSource objectAtIndex:indexPath.row] withFont:fontSize]+20;
    return CGSizeMake(width,24);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(25, 20, 5, 20);//分别为上、左、下、右
}

-(void)addDataSource:(NSArray<NSString*>*)itemList{
    self.menuDataSource = itemList;
    [self.collectionView reloadData];
}
//滑动到指定的位置
-(void)scrollAction:(NSIndexPath*)indexPath{
    NSInteger visibleCount = [self.collectionView indexPathsForVisibleItems].count;
    if(visibleCount==self.menuDataSource.count){
        return ;
    }
    NSInteger leftShowCount = kscrollCount;
    NSInteger rightShowCount = visibleCount - kscrollCount;
    
    NSIndexPath *firstIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSIndexPath *lastIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    NSInteger offsetIndex = 0;
    if(self.currentItemIndex>self.lastItemIndex){
        //向右移动
        if(lastIndexPath.row-self.currentItemIndex>=rightShowCount){
            return;
        }else{
            offsetIndex = rightShowCount - (lastIndexPath.row-self.currentItemIndex);
        }
        if(lastIndexPath.row+offsetIndex>=self.menuDataSource.count-1){
            offsetIndex = self.menuDataSource.count-1;
        }else{
            offsetIndex = lastIndexPath.row+offsetIndex;
        }
        NSIndexPath *offIndexPath = [NSIndexPath indexPathForRow:offsetIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:offIndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }else{
        //向左移动
        if(self.currentItemIndex-firstIndexPath.row>=leftShowCount){
            return;
        }else{
            offsetIndex = leftShowCount -(self.currentItemIndex-firstIndexPath.row);
            if(firstIndexPath.row-offsetIndex<=0){
                offsetIndex = 0;
            }else{
                offsetIndex = firstIndexPath.row-offsetIndex;
            }
        }
        NSIndexPath *offIndexPath = [NSIndexPath indexPathForRow:offsetIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:offIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    }
    
}

//根据高度度求宽度  text 计算的内容  Height 计算的高度 font字体大小
-(CGFloat)getWidthWithText:(NSString *)text withFont:(CGFloat)font{
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]}
                                     context:nil];
    return rect.size.width;
}

@end
