//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

// the style of animation.
typedef NS_ENUM(NSInteger,TABViewLoadAnimationStyle) {
    TABViewLoadAnimationDefault = 0,                         // default,没有动画
    TABViewLoadAnimationShort,                               // 动画先变短再变长
    TABViewLoadAnimationLong,                                // 动画先变长再变短
    TABViewLoadAnimationWithOnlySkeleton,                    // 只有骨架层
};

// the animation status to UIView or UICollectionView.
typedef NS_ENUM(NSInteger,TABViewAnimationStyle) {
    TABViewAnimationDefault = 0,               // 默认,没有动画
    TABViewAnimationStart,                     // 开始动画
    TABViewAnimationRunning,                   // 动画中 you don't need care the status.
    TABViewAnimationEnd,                       // 结束动画
    TABCollectionViewAnimationStart,           // CollectionView 开始动画
    TABCollectionViewAnimationEnd              // CollectionView 结束动画
};

// the type of superAnimation. (1.8.7 新增)
typedef NS_ENUM(NSInteger,TABViewSuperAnimationType) {
    TABViewSuperAnimationTypeDefault = 0,                    // default,没有动画
    TABViewSuperAnimationTypeClassic,                        // 经典动画类型(包含只有骨架屏，动静结合）
    TABViewSuperAnimationTypeShimmer,                        // 闪关灯动画
    TABViewSuperAnimationTypeOnlySkeleton,                   // 只有骨架屏
};

@interface UIView (Animated)

@property (nonatomic) TABViewLoadAnimationStyle loadStyle;
@property (nonatomic) TABViewAnimationStyle animatedStyle;
@property (nonatomic) TABViewSuperAnimationType superAnimationType;

@property (nonatomic) float tabViewWidth;     // width of view to you appiont it, default is your phone screen's width / 3, you can also custom it.
@property (nonatomic) float tabViewHeight;    // height of views to you appiont it, default is 20.
                                              // If your view's height is 0 when animating, you can use the property.
                                              // (1.8.7 新增)


- (float)tabViewWidth;

- (void)setTabViewWidth:(float)tabViewWidth;

@end
