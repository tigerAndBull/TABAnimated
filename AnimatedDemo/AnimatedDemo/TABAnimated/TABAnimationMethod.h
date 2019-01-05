//
//  TABAnimationMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimationMethod : NSObject

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue;

+ (CALayer *)addShimmerAnimationToView:(UIView *)view
                              duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
