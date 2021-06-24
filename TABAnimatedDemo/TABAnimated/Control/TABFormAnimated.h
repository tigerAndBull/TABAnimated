//
//  TABFormAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"
#import "TABAnimatedPullLoadingComponent.h"

NS_ASSUME_NONNULL_BEGIN

#define TABXibBundleWithClass(class) [NSBundle bundleForClass:class]

@interface TABFormAnimated : TABViewAnimated

/**
当前正在动画中的index
如果是section mode，则为section的值
如果是row mode，则为row的值
*/
@property (nonatomic, strong) NSMutableDictionary *runIndexDict;
@property (nonatomic, strong) NSMutableDictionary *runHeaderIndexDict;
@property (nonatomic, strong) NSMutableDictionary *runFooterIndexDict;

/**
 存储可执行动画的section/row
 */
@property (nonatomic, strong) NSArray <NSNumber *> *cellIndexArray;

/**
 存储样式，与cellIndexArray一一对应关系
 */
@property (nonatomic, copy) NSArray <Class> *cellClassArray;

/**
 存储数量，与cellIndexArray一一对应关系
 */
@property (nonatomic, copy) NSArray <NSNumber *> *cellCountArray;

/**
 存储头视图数据
 */
@property (nonatomic, strong) NSMutableArray <Class> *headerClassArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *headerSectionArray;

/**
 存储尾视图数据
 */
@property (nonatomic, strong) NSMutableArray <Class> *footerClassArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *footerSectionArray;

/**
 是否已经重新绑定了delegate的IMP地址
 */
@property (nonatomic, assign) BOOL isRebindDelegateIMP;

/**
 是否已经重新绑定了dataSource的IMP地址
 */
@property (nonatomic, assign) BOOL isRebindDataSourceIMP;

@property (nonatomic, assign, readonly) NSInteger runningCount;

/**
 特殊情况下才需要使用，
 仅用于动态section，即section的数量是根据获取到的数据而变化的。
 */
@property (nonatomic, assign) NSInteger animatedSectionCount;

/**
 是否可以在滚动，默认无法滚动
 */
@property (nonatomic, assign) BOOL scrollEnabled;
@property (nonatomic, assign) BOOL oldScrollEnabled;

// default is YES
@property (nonatomic, assign) BOOL scrollToTopEnabled;

/**
 上拉加载更多组件
 */
@property (nonatomic, strong) TABAnimatedPullLoadingComponent *pullLoadingComponent;

@property (nonatomic, weak, nullable) id oldDelegate;
@property (nonatomic, weak, nullable) id oldDataSource;

@property (nonatomic, assign) Class protocolContainerClass;
@property (nonatomic, strong) id protocolContainer;

#pragma mark -

- (NSInteger)getIndexWithIndex:(NSInteger)index;
- (NSInteger)getIndexWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getStringWIthIndex:(NSInteger)index;

- (NSInteger)getHeaderIndexWithIndex:(NSInteger)index;
- (NSInteger)getFooterIndexWithIndex:(NSInteger)index;

- (BOOL)getIndexIsRuning:(NSInteger)index;

- (void)rebindDelegate:(UIView *)target;
- (void)rebindDataSource:(UIView *)target;
- (void)registerViewToReuse:(UIView *)view;

- (void)addNewMethodWithSel:(SEL)oldSel newSel:(SEL)newSel;
- (void)exchangeDelegateOldSel:(SEL)oldSel newSel:(SEL)newSel target:(id)target delegate:(id)delegate;

- (void)startAnimationWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView;
- (void)refreshWithIndex:(NSInteger)index controlView:(UIView *)controlView;

- (void)reloadAnimation;
- (BOOL)reloadAnimationWithIndex:(NSInteger)index;

- (void)endAnimation;
- (BOOL)endAnimationWithIndex:(NSInteger)index;

- (void)updateScrollViewDelegateMethods:(id)delegate target:(id)target;

@end

NS_ASSUME_NONNULL_END
