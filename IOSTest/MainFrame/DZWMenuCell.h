//
//  DZWMenuCell.h
//  IOSTest
//
//  Created by limodeng on 2018/6/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZWMenuCell : UICollectionViewCell
-(void)refreshCellWithTitle:(NSString*)title withIsCurrentIndex:(BOOL)isCurrent;

@end
