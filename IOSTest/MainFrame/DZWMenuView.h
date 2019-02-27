//
//  DZWMenuView.h
//  IOSTest
//
//  Created by limodeng on 2018/6/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DZWMenuView;
@protocol DZWMenuViewDelegate<NSObject>
-(void)didSelectedWith:(DZWMenuView*)menuView withIndexPath:(NSIndexPath*)indexPath;
@end

@interface DZWMenuView : UIView

//设置数据源
-(void)addDataSource:(NSArray<NSString*>*)itemList;

//外部调用设置选中项
-(void)didSeletedWithIndex:(NSInteger)index;

@end
