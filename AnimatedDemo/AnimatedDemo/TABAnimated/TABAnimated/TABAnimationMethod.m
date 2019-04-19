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

+ (void)addAlphaAnimation:(UIView *)view {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.1f];
    animation.toValue = [NSNumber numberWithFloat:0.6f];  // 这是透明度。
    animation.autoreverses = YES;
    animation.duration = 1.0;                             // 动画循环的时间，也就是呼吸灯效果的速度
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:animation forKey:@"TABAlphaAnimation"];
}

+ (void)addShimmerAnimationToView:(UIView *)view
                         duration:(CGFloat)duration {
    UIColor *color = [UIColor whiteColor];
    // 创建渐变效果的layer
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
    
    graLayer.startPoint = CGPointMake(0, 0.6);        // 设置渐变方向起点
    graLayer.endPoint = CGPointMake(1, 1);            // 设置渐变方向终点
    
    graLayer.locations = @[@(0.3),
                           @(0.33),
                           @(0.36),
                           @(0.39),
                           @(0.42),
                           @(0.45),
                           @(0.48),
                           @(0.50)];                  // colors中各颜色对应的初始渐变点
    
    // 创建动画
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
    [graLayer addAnimation:animation forKey:@"TABLocationsAnimation"];
    // 将graLayer设置成superView的遮罩
    [view.layer setMask:graLayer];
}

@end
