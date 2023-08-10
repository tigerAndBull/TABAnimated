//
//  UIScrollView+TABAnimated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/6/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (TABAnimated)

// 停止刷新
- (void)tab_stopPullLoading;
// 永远停止刷新
- (void)tab_stopPullLoadingNoMoreData;
// 重置下拉刷新状态
- (void)tab_resetPullLoadingState;

// 添加刷新的回调
- (void)tab_addPullLoadingActionHandler:(void (^)(void))actionHandler;
// 添加刷新的事件
- (void)tab_addPullLoadinTarget:(id)target selector:(SEL)selector;

// 设置刷新的class、高度、回调
- (void)tab_addPullLoadingClass:(nonnull Class)pullLoadingClass viewHeight:(CGFloat)viewHeight actionHandler:(void (^)(void))actionHandler;
// 设置刷新的class、高度、事件
- (void)tab_addPullLoadingClass:(nonnull Class)pullLoadingClass viewHeight:(CGFloat)viewHeight target:(id)target selector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
