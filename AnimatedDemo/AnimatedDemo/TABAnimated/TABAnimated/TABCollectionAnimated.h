//
//  TABCollectionAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABCollectionAnimated : TABViewAnimated

@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic,copy) NSArray <NSValue *> *cellSizeArray;

/**
 one section init method
 When using it to init, the count decided by the table's contentSize and the cell's height, animatedCount = the table's contentSize / the cell's height.
 
 单section表格组件初始化方式
 
 @param cellClass cell，以填充contentSize的数量为标准
 @param cellSize  cell的高度
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize;

/**
 one section init method, specific animation count
 单section表格组件初始化方式
 
 @param cellClass 模版cell
 @param animatedCount 动画时row值
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount;

/**
 sections
 多section表格组件初始化方式
 
 @param cellClassArray 模版cell数组
 @param animatedCountArray 动画时row值的集合
 @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSNumber *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;

@end

NS_ASSUME_NONNULL_END
