//
//  UICollectionView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/10.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,TABCollectionViewAnimationStyle) {
    TABCollectionViewAnimationDefault = 0,     // 默认,没有动画
    TABCollectionViewAnimationStart,           // 开始动画
    TABCollectionViewAnimationEnd              // 结束动画
};

@interface UICollectionView (Animated)

@end

NS_ASSUME_NONNULL_END
