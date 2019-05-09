//
//  UICollectionView+Animated.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+TABAnimated.h"

NS_ASSUME_NONNULL_BEGIN

@class TABCollectionAnimated;

@interface UICollectionView (TABAnimated)

// To the control view
@property (nonatomic,strong) TABCollectionAnimated * _Nullable tabAnimated;

@end

NS_ASSUME_NONNULL_END
