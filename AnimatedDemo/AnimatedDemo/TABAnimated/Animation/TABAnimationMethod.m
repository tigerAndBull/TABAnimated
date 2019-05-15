//
//  TABAnimationMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimationMethod.h"
#import "TABViewAnimated.h"

@implementation TABAnimationMethod

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue {
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;
    anim.duration = duration;
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.toValue = (toValue == 0.)?@0.6:@(toValue);
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return anim;
}

+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.1f];
    animation.toValue = [NSNumber numberWithFloat:0.6f];
    animation.autoreverses = YES;
    animation.duration = 1.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:animation forKey:key];
}


+ (void)addShimmerAnimationToView:(UIView *)view
                         duration:(CGFloat)duration
                              key:(NSString *)key {
    UIColor *color = [UIColor whiteColor];
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = view.bounds;
    graLayer.name = @"TABLayer";
    
    graLayer.colors = @[(__bridge id)[color colorWithAlphaComponent:0.90].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.90].CGColor];
    
    graLayer.startPoint = CGPointMake(0, 0.6);
    graLayer.endPoint = CGPointMake(1, 1);
    
    graLayer.locations = @[@(0.3),
                           @(0.33),
                           @(0.36),
                           @(0.39),
                           @(0.42),
                           @(0.45),
                           @(0.48),
                           @(0.50)];
    

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = (duration > 0.)?duration:1.5f;
    
    CGFloat cutFloat = 0.6f;
    CGFloat addFloat = 0.5f;
    
    animation.fromValue = @[@(0.3-cutFloat),
                            @(0.33-cutFloat),
                            @(0.36-cutFloat),
                            @(0.39-cutFloat),
                            @(0.42-cutFloat),
                            @(0.45-cutFloat),
                            @(0.48-cutFloat),
                            @(0.50-cutFloat)];
    
    animation.toValue = @[@(0.3+addFloat),
                          @(0.33+addFloat),
                          @(0.36+addFloat),
                          @(0.39+addFloat),
                          @(0.42+addFloat),
                          @(0.45+addFloat),
                          @(0.48+addFloat),
                          @(0.50+addFloat)];
    
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:key];
    [view.layer setMask:graLayer];
}

+ (void)addDropAnimation:(CALayer *)layer
                   index:(NSInteger)index
                duration:(CGFloat)duration
                   count:(NSInteger)count
                stayTime:(CGFloat)stayTime
               deepColor:(UIColor *)deepColor
                     key:(NSString *)key {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"backgroundColor"];
    animation.values = @[
                         (id)deepColor.CGColor,
                         (id)layer.backgroundColor,
                         (id)layer.backgroundColor,
                         (id)deepColor.CGColor
                         ];
    
    animation.keyTimes = @[@0,@(stayTime),@1,@1];
    // count+3 为了增加末尾的等待时间，不然显得很急促
    animation.beginTime = CACurrentMediaTime() + index*(duration/(count+3));
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:key];
}

@end
