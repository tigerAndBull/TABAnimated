//
//  TABAnimationMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+TABAnimated.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Methods in the file are about to animation type.
 **/
@interface TABAnimationMethod : NSObject

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue;

+ (void)addShimmerAnimationToView:(UIView *)view
                         duration:(CGFloat)duration
                              key:(NSString *)key;

+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
