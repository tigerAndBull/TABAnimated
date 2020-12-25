//
//  TABTableAnimated.h
//  TABAnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TABFormAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABTableAnimated : TABFormAnimated

#pragma mark - readwrite

/**
 1种cell样式时，UITableView的cellHeight
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 cell样式  > 1 时，UITableView的cellHeight集合
 */
@property (nonatomic, copy) NSArray <NSNumber *> *cellHeightArray;

/**
 section为1时，设置对应的row数量
 多section时，统一设置所有section的row数量
 */
@property (nonatomic, assign) NSInteger animatedCount;

/**
 UITableView动画启动时，同时启动UITableViewHeaderView， 默认是YES
 */
@property (nonatomic, assign) BOOL showTableHeaderView;

/**
 UITableView动画启动时，同时启动UITableViewFooterView， 默认是YES
 */
@property (nonatomic, assign) BOOL showTableFooterView;

#pragma mark - readonly, 不建议重写的属性

/**
 缓存自适应高度值
 */
@property (nonatomic, assign) CGFloat oldEstimatedRowHeight;

@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *headerHeightArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *footerHeightArray;

// 与tableHeaderView对应的参数设置
@property (nonatomic, strong) TABViewAnimated *tabHeadViewAnimated;

// 与tableFooterView对应的参数设置
@property (nonatomic, strong) TABViewAnimated *tabFooterViewAnimated;

#pragma mark - 以下均为以section为单位的初始化方法

/**
 单section表格组件初始化方式，row值以填充contentSize的数量为标
 
 @param cellClass cell，以填充contentSize的数量为标准
 @param cellHeight  cell的高度
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight;

/**
 单section表格组件初始化方式，row值以animatedCount为准
 
 @param cellClass 目标cell
 @param animatedCount 动画时row的数量
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount;

/**
 指定某个section，且与row无关，使用该初始化方法
 动画数量以填充contentSize的数量为准
 
 @param cellClass 注册的cell类型
 @param cellHeight 动画时cell高度
 @param section 被指定的section
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                            toSection:(NSInteger)section;

/**
 如果原UITableView是多个section，但是只想指定一个section启动动画，使用该初始化方法
 
 @param cellClass 注册的cell类型
 @param cellHeight 动画时cell高度
 @param animatedCount 指定section的动画数量
 @param section 被指定的section
 @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount
                            toSection:(NSInteger)section;

/**
 视图结构要求：section和cell样式一一对应
 
 @param cellClassArray 目标cell数组
 @param animatedCountArray 动画时row的数量集合
 @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;

/**
 视图结构要求：section和cell样式一一对应
 
 请保证animatedSectionArray升序
 
 上一个初始化方式，section和数组元素顺序对应，所有section都会有动画
 现在可以根据animatedSectionArray指定section，不指定的section没有动画。
 
 举个例子：
 比如 animatedSectionArray = @[@(3),@(4)];
 意思是 cellHeightArray, animatedCountArray, cellClassArray数组中的第一个元素，是 section == 3 的动画数据
 
 @param cellClassArray 目标cell数组
 @param cellHeightArray 目标cell对应高度
 @param animatedCountArray 对应section动画数量
 @param animatedSectionArray animatedSectionArray
 @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray;

#pragma mark - 以下均为以row为单位的初始化方法

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 指定某个row配置动画
 animatedCount只能为1，无法设置animatedCount，只能为1
 
 @param cellClass 注册的cell类型
 @param cellHeight 动画时cell高度
 @param row 被指定的row
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClass:(Class)cellClass
                                    cellHeight:(CGFloat)cellHeight
                                         toRow:(NSInteger)row;

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 该section中所有row均会配置动画
 animatedCount只能为1，无法设置animatedCount，只能为1
 
 @param cellClassArray 目标cell数组
 @param cellHeightArray 目标cell对应高度
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray;

/**
 视图结构要求：1个section对应多个cell，且只有1个section
 
 指定row集合，不指定的row会执行你的代理方法。
 
 @param cellClassArray 目标cell数组
 @param cellHeightArray 目标cell对应高度
 @param rowArray rowArray
 @return object
 */
+ (instancetype)animatedInRowModeWithCellClassArray:(NSArray <Class> *)cellClassArray
                                    cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                                           rowArray:(NSArray <NSNumber *> *)rowArray;

#pragma mark - 添加 header / footer

/**
 添加区头动画，指定section
 
 @param headerViewClass 区头类对象
 @param viewHeight 区头高度
 @param section 指定的section
 */
- (void)addHeaderViewClass:(nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section;


/**
 添加区尾动画，指定section

 @param footerViewClass 区尾类对象
 @param viewHeight 区尾高度
 @param section 指定的section
 */
- (void)addFooterViewClass:(nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section;

#pragma mark - 用于动态section 配合animatedSectionCount使用

- (void)addHeaderViewClass:(nonnull Class)headerViewClass viewHeight:(CGFloat)viewHeight;
- (void)addFooterViewClass:(nonnull Class)footerViewClass viewHeight:(CGFloat)viewHeight;

#pragma mark - DEPRECATED

+ (instancetype)animatedWithCellClass:(Class)cellClass DEPRECATED_MSG_ATTRIBUTE("该回调在v2.3.0被弃用，请使用`animatedWithCellClass:cellHeight:`取代");

@end

NS_ASSUME_NONNULL_END
