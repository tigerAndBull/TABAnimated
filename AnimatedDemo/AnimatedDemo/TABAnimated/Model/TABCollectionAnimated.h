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

/**
 单section的UICollectionView的cellSize
 */
@property (nonatomic,assign) CGSize cellSize;

/**
 多section的UICollectionView的cellSize集合
 */
@property (nonatomic,strong) NSArray <NSValue *> *cellSizeArray;

/**
 指定section加载动画集合
 */
@property (nonatomic,strong) NSArray <NSNumber *> *animatedSectionArray;

/**
 当前正在动画中的分区
 */
@property (nonatomic,strong) NSMutableArray <NSNumber *> *runAnimationSectionArray;

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
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;

/**
 这个初始化方式为部分section需要动画的UICollectionView提供
 
 上一个初始化方式，section和数组元素依次对应，所有section都会有动画
 现在可以根据animatedSectionArray指定section，不指定的section没有动画。
 
 举个例子：
 比如 animatedSectionArray = @[@(3),@(4)];
 意思是 cellSizeArray,animatedCountArray,cellClassArray数组中的第一个元素，是 section == 3 的动画数据
 
 @param cellClassArray 模版cell数组
 @param cellSizeArray 模版cell对应size
 @param animatedCountArray 对应section动画数量
 @param animatedSectionArray animatedSectionArray
 @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray;

- (BOOL)currentSectionIsAnimating:(UICollectionView *)collectionView
                          section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
