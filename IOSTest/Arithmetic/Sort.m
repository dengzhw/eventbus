//
//  Sort.m
//  IOSTest
//
//  Created by limodeng on 2018/8/20.
//  Copyright © 2018年 milodeng. All rights reserved.
//

#import "Sort.h"

@implementation Sort

/*排序算法一：快速排序
*/
-(void)quickSort{
    @autoreleasepool{
        @autoreleasepool{
            NSMutableArray * arr = @[@6,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10].mutableCopy;
            [self quickSortArray:arr withLeftIndex:0 andRightIndex:arr.count-1];
        }
    }

}

/*排序算法二：简单排序
 */

-(void)simpleSort{
    @autoreleasepool{
        @autoreleasepool{
            NSMutableArray * arr = @[@6,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10].mutableCopy;
            [self simpleSortWithArray:arr];
            NSLog(@"simpleSort sort:%@",arr);
        }
    }
}
/*排序算法三 ：冒泡排序
 */
 
-(void)bubSort{
    @autoreleasepool{
        @autoreleasepool{
            NSMutableArray * arr = @[@6,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10].mutableCopy;
            [self bubSortWithArray:arr];
            NSLog(@"bubSort sort:%@",arr);
        }
    }
}

/*排序算法四:插入排序
 */

-(void)insertSort{
    @autoreleasepool{
        @autoreleasepool{
            NSMutableArray * arr = @[@6,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10].mutableCopy;
            [self insertSortWithArray:arr];
            NSLog(@"insertSort sort:%@",arr);
        }
    }
}

/*排序算法五：堆排序
*/

-(void)heapSort{
    @autoreleasepool{
        @autoreleasepool{
            NSMutableArray * arr = @[@6,@1,@2,@9,@7,@12,@5,@3,@8,@13,@10].mutableCopy;
            [self heapSortWithArray:arr];
            NSLog(@"insertSort sort:%@",arr);
        }
    }
}


#pragma mark --imp
//快速排序算法
- (void)quickSortArray:(NSMutableArray *)array withLeftIndex:(NSInteger)leftIndex andRightIndex:(NSInteger)rightIndex{
    if (leftIndex >= rightIndex) {//如果数组长度为0或1时返回
        return ;
    }
    
    NSInteger i = leftIndex;
    NSInteger j = rightIndex;
    //记录比较基准数
    NSInteger key = [array[i] integerValue];
    
    while (i < j) {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i < j && [array[j] integerValue] >= key) {//如果比基准数大，继续查找
            j--;
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        array[i] = array[j];
        
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i < j && [array[i] integerValue] <= key) {//如果比基准数小，继续查找
            i++;
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        array[j] = array[i];
        
    }
    
    //将基准数放到正确位置
    array[i] = @(key);
    
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quickSortArray:array withLeftIndex:leftIndex andRightIndex:i - 1];
    //排序基准数右边的
    [self quickSortArray:array withLeftIndex:i + 1 andRightIndex:rightIndex];
}

//简单快速排序
-(void)simpleSortWithArray:(NSMutableArray*)array{
    for (NSInteger i = 0; i<array.count-1; i++) {
        NSInteger min = i;
        for (NSInteger j= i+1; j<array.count; j++) {
            if([array[j] integerValue]<[array[min] integerValue]){
                min = j;
            }
        }
        if(min!=i){
            [array exchangeObjectAtIndex:i withObjectAtIndex:min];
        }
    }
}
//冒泡排序
-(void)bubSortWithArray:(NSMutableArray*)array{
    for (NSInteger i = 0; i<array.count-1; i++) {
        for (NSInteger j=0; j<array.count-i-1; j++) {
            if([array[j] integerValue]<[array[j+1] integerValue]){
                [array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }
    }
}

//插入排序
-(void)insertSortWithArray:(NSMutableArray*)array{
    for (NSInteger i =0; i<array.count; i++) {
        for (NSInteger j = i; j>0; j--) {
            if([array[j] integerValue]<[array[j-1] integerValue]){
                [array exchangeObjectAtIndex:j withObjectAtIndex:j-1];
            }
        }
    }
}


#pragma mark heapSort method

-(void)adjustHeapWithArray:(NSMutableArray*)array withLocation:(NSInteger)location withLen:(NSInteger)len{
    NSInteger left = location*2+1; //root的左子树位置
    NSInteger right = location*2+2;//root的右子树位置
    while (right<len) {
        //左孩子和右孩子的值都小于root值不用调整。
        if([array[location] integerValue]>=[array[left] integerValue] &&[array[location] integerValue]>[array[right] integerValue]){
            return ;
        }
        //左孩子值大于右孩子值，将左孩子与root交换
        if([array[left] integerValue]>[array[right] integerValue]){
            [array exchangeObjectAtIndex:location withObjectAtIndex:left];
            location = left;
        }else{
            //右孩子值大于左孩子值，将右孩子与root交换
            [array exchangeObjectAtIndex:location withObjectAtIndex:right];
            location = right;
        }
        //调整下个孩子结点
        left = location*2+1;
        right = left+1;
    }
    //只有左子树且子树大于root
    if(left<len&&array[left]>array[location]){
        [array exchangeObjectAtIndex:left withObjectAtIndex:location];
    }
    
}

//堆排序
-(void)heapSortWithArray:(NSMutableArray*)array{
    NSInteger size = array.count;
    //创建大根堆
    for (NSInteger i = size/2-1; i>=0; i--) {
        [self adjustHeapWithArray:array withLocation:i withLen:size];
    }
    //排序
    while (size>0) {
        [array exchangeObjectAtIndex:size-1 withObjectAtIndex:0];//将根（最大）与数组最未交换
        size--;//树大小减少
        NSLog(@"heapSort:%@",array[size]);
        [self adjustHeapWithArray:array withLocation:0 withLen:size];
    }
}

@end
