//
//  TABAnimatedPullLoadingComponent.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/6/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TABAnimatedPullLoadingState) {
    // 普通闲置状态
    TABAnimatedPullLoadingStateNormal = 0,
    // 正在刷新中
    TABAnimatedPullLoadingStateRefreshing,
    // 停止刷新
    TABAnimatedPullLoadingStateStopped,
    // 没有更多的数据了
    TABAnimatedPullLoadingStateNoMoreData
};

typedef void(^TABAnimatedFooterActionHandler)(void);

@interface TABAnimatedPullLoadingComponent : UIView

@property (nonatomic, assign) TABAnimatedPullLoadingState state;
// 最开始的contentInset
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, copy) TABAnimatedFooterActionHandler actionHandler;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@property (nonatomic, assign) Class targetClass;
@property (nonatomic, assign) CGFloat viewHeight;

- (void)addObservers;
- (void)removeObservers;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView targetClass:(Class)targetClass viewHeight:(CGFloat)viewHeight actionHandler:(TABAnimatedFooterActionHandler)actionHandler;
- (instancetype)initWithScrollView:(UIScrollView *)scrollView targetClass:(Class)targetClass viewHeight:(CGFloat)viewHeight target:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
