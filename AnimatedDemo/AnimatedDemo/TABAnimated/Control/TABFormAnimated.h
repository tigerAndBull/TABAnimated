//
//  TABFormAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <TABAnimated/TABAnimated.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TABFormAnimatedAreaCell,
    TABFormAnimatedAreaHeader,
    TABViewAnimationFooter,
} TABFormAnimatedAreaType;

typedef void(^TABFormSyncCompletion)();

@interface TABFormAnimated : TABViewAnimated

@property (nonatomic, strong) NSMutableDictionary *runIndexDict;
@property (nonatomic, strong) NSMutableDictionary *runHeaderIndexDict;
@property (nonatomic, strong) NSMutableDictionary *runFooterIndexDict;

/**
 当前正在动画中的index
 如果是section mode，则为section的值
 如果是row mode，则为row的值
 */
@property (nonatomic, strong) NSArray <NSNumber *> *cellIndexArray;

/**
 一个section对应一种cell
 */
@property (nonatomic, copy) NSArray <Class> *cellClassArray;

/**
 多个section使用该属性，设置动画时row数量
 当数组数量大于section数量，多余数据将舍弃
 当数组数量小于seciton数量，剩余部分动画时row的数量为默认值
 */
@property (nonatomic, copy) NSArray <NSNumber *> *cellCountArray;

/**
 存储头视图相关
 */
@property (nonatomic, strong) NSMutableArray <Class> *headerClassArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *headerSectionArray;

/**
 存储尾视图相关
 */
@property (nonatomic, strong) NSMutableArray <Class> *footerClassArray;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *footerSectionArray;

/**
 是否已经交换了delegate的IMP地址
 */
@property (nonatomic, assign) BOOL isExhangeDelegateIMP;

/**
 是否已经交换了dataSource的IMP地址
 */
@property (nonatomic, assign) BOOL isExhangeDataSourceIMP;

@property (nonatomic, assign) NSInteger maxDataCount;
@property (nonatomic, assign, readonly) NSInteger runningCount;

/**
 特殊情况下才需要使用，
 仅用于动态section，即section的数量是根据获取到的数据而变化的。
 */
@property (nonatomic, assign) NSInteger animatedSectionCount;

@property (nonatomic, copy) TABFormSyncCompletion syncCompletion;

- (NSInteger)getIndexWithIndex:(NSInteger)index;
- (NSInteger)getIndexWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getStringWIthIndex:(NSInteger)index;
- (NSInteger)currentIndexIsAnimatingWithIndex:(NSInteger)index type:(TABFormAnimatedAreaType)type;

- (NSInteger)getHeaderIndexWithIndex:(NSInteger)index;
- (NSInteger)getFooterIndexWithIndex:(NSInteger)index;

- (void)exchangeDelegate:(UIView *)target;
- (void)exchangeDataSource:(UIView *)target;
- (void)registerViewToReuse:(UIView *)view;

- (void)exchangeDelegateOldSel:(SEL)oldSelector newSel:(SEL)newSelector target:(id)target delegate:(id)delegate;

- (void)startAnimationWithIndex:(NSInteger)index isFirstLoad:(BOOL)isFirstLoad controlView:(UIView *)controlView;

- (void)startAnimation;
- (void)startAnimationWithIndex:(NSInteger)index;

- (void)endAnimation;
- (void)endAnimationWithIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
