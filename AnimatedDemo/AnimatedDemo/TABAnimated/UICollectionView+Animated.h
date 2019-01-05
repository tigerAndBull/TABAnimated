//
//  UICollectionView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Animated.h"

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (Animated)

@property (nonatomic) TABViewAnimationStyle animatedStyle;

@property (nonatomic) NSInteger animatedCount;    // default is six. count of cell during animating.
@property (nonatomic) NSInteger sectionCount;

@end

NS_ASSUME_NONNULL_END
