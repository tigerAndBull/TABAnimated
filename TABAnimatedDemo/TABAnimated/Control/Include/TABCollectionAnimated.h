//
//  TABCollectionAnimated.h
//  TABAnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABFormAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABCollectionAnimated : TABFormAnimated

#pragma mark - readwrite

/**
 cell样式 == 1时，UICollectionView的cellSize。
 */
@property (nonatomic, assign) CGSize cellSize;

/**
 cell样式 > 1时，UICollectionView的cellSize集合。
 */
@property (nonatomic, copy) NSArray <NSValue *> *cellSizeArray;

/**
 设置单section动画时row数量，默认填充屏幕为准
 **/
@property (nonatomic, assign) NSInteger animatedCount;

#pragma mark - readonly, 不建议重写的属性

@property (nonatomic, strong, readonly) NSMutableArray <NSValue *> *headerSizeArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSValue *> *footerSizeArray;

// 绑定瀑布流高度代理的sel
@property (nonatomic, assign) SEL waterFallLayoutHeightSel;

// 如果你的代理就是dataSource的代理，就不用设置
@property (nonatomic, weak) id waterFallLayoutDelegate;

@property (nonatomic, copy) NSArray <NSNumber *> *waterFallLayoutHeightArray;

#pragma mark -

/**
 单section表格组件初始化方式，row值以填充contentSize的数量为标准
 
 @param cellClass cell，以填充contentSize的数量为标准
 @param cellSize  cell的高度
 @return 目标对象
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize;

/**
 单section表格组件初始化方式，row值以填充contentSize的数量为标准
 
 @param cellClass 模版cell
 @param animatedCount 动画时row值
 @return 目标对象
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount;

#pragma mark - 以下均为以section为单位的初始化方法

/**
 如果原UICollectionView是多个section，但是只想指定一个section启动动画，使用该初始化方法
 动画数量以填充contentSize的数量为标准
 
 @param cellClass 注册的cell类型
 @param cellSize 动画时cell的size
 @param section 被指定的section
 @return 目标对象
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                            toSection:(NSInteger)section;

/**
 如果原UICollectionView是多个section，但是只想指定一个section启动动画，使用该初始化方法
 
 @param cellClass 注册的cell类型
 @param cellSize 动画时cell的size
 @param animatedCount 指定section的动画数量
 @param section 被指定的section
 @return 目标对象
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                             cellSize:(CGSize)cellSize
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section;

/**
 视图结构要求：section和cell样式一一对应
 
 @param cellClassArray 模版cell数组
 @param animatedCountArray 动画时row值的集合
 @return 目标对象
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;

/**
 视图结构要求：section和cell样式一一对应
 
 上一个初始化方式，section和数组元素依次对应，所有section都会有动画
 现在可以根据animatedSectionArray指定section，不指定的section没有动画。
 
 举个例子：
 比如 animatedSectionArray = @[@(3),@(4)];
 意思是 cellSizeArray,animatedCountArray,cellClassArray数组中的第一个元素，是 section == 3 的动画数据
 
 @param cellClassArray 模版cell数组
 @param cellSizeArray 模版cell对应size
 @param animatedCountArray 对应section动画数量
 @param animatedSectionArray animatedSectionArray
 @return 目标对象
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                             cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray;

#pragma mark - 以下均为以row为单位的初始化方法

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 指定row配置动画
 animatedCount只能为1，无法设置animatedCount，只能为1
 
 @param cellClass 注册的cell类型
 @param cellSize 动画时cell size
 @param row 被指定的row
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                      cellSize:(CGSize)cellSize
                                         toRow:(NSInteger)row;

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 该section中所有row均会配置动画
 animatedCount只能为1，无法设置animatedCount，只能为1
 
 @param cellClassArray 目标cell数组
 @param cellSizeArray 目标cell对应size集合
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray;

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 此初始化指定row，不指定的row会执行你的代理方法。
 
 举个例子：
 比如 animatedRowArray = @[@(3),@(4)];
 意思是 cellHeightArray，animatedCountArray，cellClassArray数组中的第一个元素，是 row == 3 的动画数据
 
 @param cellClassArray 目标cell数组
 @param cellSizeArray 目标cell对应size
 @param rowArray rowArray
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                      cellSizeArray:(NSArray <NSValue *> *)cellSizeArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray;

#pragma mark - 瀑布流

+ (instancetype)animatedWaterFallLayoutWithCellClass:(Class)cellClass
                                         heightArray:(NSArray <NSNumber *> *)heightArray
                                           heightSel:(SEL)heightSel;

#pragma mark - Header / Footer

/**
 添加区头动画，指定section
 
 @param headerViewClass 区头类对象
 @param viewSize 区头size
 @param section 指定的section
 */
- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section;


/**
 添加区尾动画，指定section
 
 @param footerViewClass 区尾类对象
 @param viewSize 区尾size
 @param section 指定的section
 */
- (void)addFooterViewClass:(_Nonnull Class)footerViewClass
                  viewSize:(CGSize)viewSize
                 toSection:(NSInteger)section;

#pragma mark - 用于动态section 配合animatedSectionCount使用

- (void)addHeaderViewClass:(_Nonnull Class)headerViewClass viewSize:(CGSize)viewSize;
- (void)addFooterViewClass:(_Nonnull Class)footerViewClass viewSize:(CGSize)viewSize;


@end

NS_ASSUME_NONNULL_END
