//
//  TABTableAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TABViewAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABTableAnimated : TABViewAnimated

/**
 * 单section的UITableView的cellHeight
 */
@property (nonatomic,assign) CGFloat cellHeight;

/**
 * 多section的UITableView的cellHeight集合
 */
@property (nonatomic,strong) NSArray <NSNumber *> *cellHeightArray;

/**
 * 指定section加载动画集合
 */
@property (nonatomic,strong) NSArray <NSNumber *> *animatedSectionArray;

/**
 * 当前正在动画中的分区
 */
@property (nonatomic,strong) NSMutableArray <NSNumber *> *runAnimationSectionArray;

/**
 * 头视图动画对象
 */
@property (nonatomic,weak) TABViewAnimated *tabHeadViewAnimated;

/**
 * 尾视图动画对象
 */
@property (nonatomic,weak) TABViewAnimated *tabFooterViewAnimated;

/**
 * 缓存自适应高度值
 */
@property (nonatomic,assign) CGFloat oldEstimatedRowHeight;

/**
 * 控制动画时的分区数量
 */
@property (nonatomic,assign) NSInteger animatedSectionCount;

/**
 * UITableView动画启动时，同时启动UITableViewHeaderView
 */
@property (nonatomic,assign) BOOL showTableHeaderView;

/**
 * UITableView动画启动时，同时启动UITableViewFooterView
 */
@property (nonatomic,assign) BOOL showTableFooterView;

/**
 * 单section表格组件初始化方式，row值以填充contentSize的数量为标准
 * one section init method
 * When using it to init, the count decided by the table's contentSize and the cell's height, animatedCount = the table's contentSize / the cell's height.
 *
 * @param cellClass cell，以填充contentSize的数量为标准
 * @param cellHeight  cell的高度
 * @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight;

/**
 * 单section表格组件初始化方式，row值以填充contentSize的数量为标准
 * one section init method, specific animation count
 *
 * @param cellClass 目标cell
 * @param animatedCount 动画时row的数量
 * @return object
 */
+ (instancetype)animatedWithCellClass:(Class)cellClass
                           cellHeight:(CGFloat)cellHeight
                        animatedCount:(NSInteger)animatedCount;

/**
 * 多section表格组件初始化方式
 * to sections
 *
 * @param cellClassArray 目标cell数组
 * @param animatedCountArray 动画时row的数量集合
 * @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray;


/**
 * 这个初始化方式为部分section需要动画提供
 *
 * 上一个初始化方式，section和数组元素顺序对应，所有section都会有动画
 * 现在可以根据animatedSectionArray指定section，不指定的section没有动画。
 *
 * 举个例子：
 * 比如 animatedSectionArray = @[@(3),@(4)];
 * 意思是 cellHeightArray,animatedCountArray,cellClassArray数组中的第一个元素，是 section == 3 的动画数据
 *
 * @param cellClassArray 目标cell数组
 * @param cellHeightArray 目标cell对应高度
 * @param animatedCountArray 对应section动画数量
 * @param animatedSectionArray animatedSectionArray
 * @return object
 */
+ (instancetype)animatedWithCellClassArray:(NSArray <Class> *)cellClassArray
                           cellHeightArray:(NSArray <NSNumber *> *)cellHeightArray
                        animatedCountArray:(NSArray <NSNumber *> *)animatedCountArray
                      animatedSectionArray:(NSArray <NSNumber *> *)animatedSectionArray;

/**
 * 判断指定分区是否在动画中
 * 
 * @param tableView tableView 目标组件
 * @param section section 目标section
 * @return return value 是否在动画中
 */
- (BOOL)currentSectionIsAnimating:(UITableView *)tableView
                          section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
