//
//  TABAnimatedFooterComponent.h
//  AnimatedDemo
//
//  Created by 安文虎 on 2020/6/3.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TABAnimatedFooterRefreshState) {
    // 普通闲置状态
    TABAnimatedFooterRefreshStateNormal = 0,
    // 正在刷新中
    TABAnimatedFooterRefreshStateRefreshing,
    // 没有更多的数据了
    TABAnimatedFooterRefreshStateNoMoreData
};

@interface TABAnimatedFooterComponent : UIView

@property (nonatomic, assign) TABAnimatedFooterRefreshState state;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak) UIScrollView *scrollView;

- (void)addObservers;
- (void)removeObservers;

@end

NS_ASSUME_NONNULL_END
