//
//  UIView+Animated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

// the type of animation.
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
    TABCollectionViewAnimationRunning,         // CollectionView 动画中
    TABCollectionViewAnimationEnd              // CollectionView 结束动画
};

@interface UIView (Animated)

@property (nonatomic) TABViewLoadAnimationStyle loadStyle;
@property (nonatomic) TABViewAnimationStyle animatedStyle;

@property (nonatomic) CGFloat tabViewWidth;    // width of view to you appiont it, default is your phone screen's width / 3, you can also custom it.

@end
