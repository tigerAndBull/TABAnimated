//
//  TABTableAnimated.h
//  AnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TABViewAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@class TABComponentManager;

@interface TABTableAnimated : TABViewAnimated

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
 仅用于动态section，即section的数量是根据获取到的数据而变化的。
 */
@property (nonatomic, assign) NSInteger animatedSectionCount;

/**
 设置单个section单个cell样式时动画的数量，默认填充屏幕为准
 */
@property (nonatomic, assign) NSInteger animatedCount;

/**
 UITableView动画启动时，同时启动UITableViewHeaderView
 */
@property (nonatomic, assign) BOOL showTableHeaderView;

/**
 UITableView动画启动时，同时启动UITableViewFooterView
 */
@property (nonatomic, assign) BOOL showTableFooterView;

/**
 头视图动画对象
 */
@property (nonatomic, weak) TABViewAnimated *tabHeadViewAnimated;

/**
 尾视图动画对象
 */
@property (nonatomic, weak) TABViewAnimated *tabFooterViewAnimated;

#pragma mark - readonly, 不建议重写的属性

/**
 你不需要手动赋值，但是你需要知道当前视图的结构，
 从而选择初始化方法和启动方法。
 */
@property (nonatomic, assign, readonly) TABAnimatedRunMode runMode;

/**
 指定cell样式加载动画的集合
 集合内为cell样式所在的indexPath
 */
@property (nonatomic, copy) NSArray <NSNumber *> *animatedIndexArray;

/**
 当前正在动画中的index
 如果是section mode，则为section的值
 如果是row mode，则为row的值 
 */
@property (nonatomic, strong) NSMutableArray <NSNumber *> *runAnimationIndexArray;

/**
 缓存自适应高度值
 */
@property (nonatomic, assign) CGFloat oldEstimatedRowHeight;

/**
 是否已经交换了delegate的IMP地址
 */
@property (nonatomic, assign, readonly) BOOL isExhangeDelegateIMP;

/**
 是否已经交换了dataSource的IMP地址
 */
@property (nonatomic, assign, readonly) BOOL isExhangeDataSourceIMP;

/**
 存储头视图相关
 */
@property (nonatomic, strong, readonly) NSMutableArray <Class> *headerClassArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *headerHeightArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *headerSectionArray;

/**
 存储尾视图相关
 */
@property (nonatomic, strong, readonly) NSMutableArray <Class> *footerClassArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *footerHeightArray;
@property (nonatomic, strong, readonly) NSMutableArray <NSNumber *> *footerSectionArray;

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
 
 上一个初始化方式，section和数组元素顺序对应，所有section都会有动画
 现在可以根据animatedSectionArray指定section，不指定的section没有动画。
 
 举个例子：
 比如 animatedSectionArray = @[@(3),@(4)];
 意思是 cellHeightArray,animatedCountArray,cellClassArray数组中的第一个元素，是 section == 3 的动画数据
 
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
- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section;

/**
 添加区头动画
 不指定section，意味着所有section都会加入该区头动画，
 仅设置animatedSectionCount属性生效
 
 @param headerViewClass 区头类对象
 @param viewHeight 区头高度
 */
- (void)addHeaderViewClass:(__nonnull Class)headerViewClass
                viewHeight:(CGFloat)viewHeight;

/**
 添加区尾动画，指定section

 @param footerViewClass 区尾类对象
 @param viewHeight 区尾高度
 @param section 指定的section
 */
- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight
                 toSection:(NSInteger)section;

/**
 添加区尾动画
 不指定section，意味着所有section都会加入该区尾动画，
 仅设置animatedSectionCount属性生效
 
 @param footerViewClass 区尾类对象
 @param viewHeight 区尾高度
 */
- (void)addFooterViewClass:(__nonnull Class)footerViewClass
                viewHeight:(CGFloat)viewHeight;

#pragma mark -

- (NSInteger)headerNeedAnimationOnSection:(NSInteger)section;

- (NSInteger)footerNeedAnimationOnSection:(NSInteger)section;

- (void)exchangeTableViewDelegate:(UITableView *)target;

- (void)exchangeTableViewDataSource:(UITableView *)target;

+ (instancetype)animatedWithCellClass:(Class)cellClass DEPRECATED_MSG_ATTRIBUTE("该回调在v2.3.0被弃用，请使用`animatedWithCellClass:cellHeight:`取代");

@end

#pragma mark -

@interface EstimatedTableViewDelegate : NSObject

@end


NS_ASSUME_NONNULL_END
