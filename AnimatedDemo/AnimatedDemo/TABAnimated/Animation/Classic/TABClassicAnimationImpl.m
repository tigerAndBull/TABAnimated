//
//  TABClassicAnimationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABClassicAnimationImpl.h"

@implementation TABClassicAnimationImpl

#pragma mark - TABAnimatedDecorateInterface

- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray <TABComponentLayer *> *)layers {
    
}

- (CABasicAnimation *)_scaleXAnimationDuration:(CGFloat)duration toValue:(CGFloat)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.toValue = (toValue == 0.)?@0.6:@(toValue);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end
