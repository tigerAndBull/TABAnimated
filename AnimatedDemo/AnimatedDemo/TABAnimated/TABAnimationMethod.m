//
//  TABAnimationMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimationMethod.h"

@implementation TABAnimationMethod

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue {
    
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    anim.removedOnCompletion = NO;        // 保证从前台进入后台仍能执行
    anim.duration = duration;
    anim.autoreverses = YES;              // 往返都有动画
    anim.repeatCount = HUGE_VALF;         // 执行次数
    anim.toValue = (toValue == 0.)?@0.6:@(toValue);
    
    return anim;
}

+ (CALayer *)addShimmerAnimationToView:(UIView *)view
                              duration:(CGFloat)duration {
    
    UIColor *color = [UIColor redColor];
    // 创建渐变效果的layer
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = view.bounds;
    graLayer.name = @"TABLayer";
    
    graLayer.colors = @[
                        (__bridge id)[color colorWithAlphaComponent:0.90].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.40].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.50].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.70].CGColor,
                        (__bridge id)[color colorWithAlphaComponent:0.90].CGColor
                        ];
    
    graLayer.startPoint = CGPointMake(0, 0.6);        // 设置渐变方向起点
    graLayer.endPoint = CGPointMake(1, 1);            // 设置渐变方向终点
    
    graLayer.locations = @[
                           @(0.3),
                           @(0.33),
                           @(0.36),
                           @(0.39),
                           @(0.42),
                           @(0.45),
                           @(0.48),
                           @(0.50)
                           ];                         // colors中各颜色对应的初始渐变点
    
    // 创建动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.duration = (duration > 0.)?duration:1.5f;
    
    animation.fromValue = @[
                            @(0.3-0.6),
                            @(0.33-0.6),
                            @(0.36-0.6),
                            @(0.39-0.6),
                            @(0.42-0.6),
                            @(0.45-0.6),
                            @(0.48-0.6),
                            @(0.50-0.6)
                            ];
    
    animation.toValue = @[
                          @(0.3+0.5),
                          @(0.33+0.5),
                          @(0.36+0.5),
                          @(0.39+0.5),
                          @(0.42+0.5),
                          @(0.45+0.5),
                          @(0.48+0.5),
                          @(0.50+0.5)
                          ];
    
    animation.removedOnCompletion = NO;
    animation.repeatCount = HUGE_VALF;
    animation.fillMode = kCAFillModeForwards;
    [graLayer addAnimation:animation forKey:@"TABLocationsAnimation"];
    
    // 将graLayer设置成superView的遮罩
    view.layer.mask = graLayer;
    return graLayer;
}

@end
