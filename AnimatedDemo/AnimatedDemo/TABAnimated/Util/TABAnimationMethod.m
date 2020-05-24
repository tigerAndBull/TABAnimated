//
//  TABAnimationMethod.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimationMethod.h"

@implementation TABAnimationMethod

+ (void)addEaseOutAnimation:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    [view.layer addAnimation:animation forKey:@"animation"];
}

@end
