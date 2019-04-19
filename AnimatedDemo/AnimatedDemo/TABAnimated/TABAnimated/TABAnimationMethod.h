//
//  TABAnimationMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Animated.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimationMethod : NSObject

+ (void)addShimmerAnimationToView:(UIView *)view
                         duration:(CGFloat)duration;

+ (void)addAlphaAnimation:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
