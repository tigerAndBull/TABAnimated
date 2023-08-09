//
//  TABClassicAnimationImpl.m
//  TABAnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABClassicAnimationImpl.h"
#import "TABComponentLayer+TABClassicAnimation.h"
#import "TABAnimated.h"

static NSString * const kAnimatedClassicAnimation = @"kAnimatedClassicAnimation";

@implementation TABClassicAnimationImpl

- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray <TABComponentLayer *> *)layers {
    for (TABComponentLayer *layer in layers) {
        if (layer.baseAnimationType == TABComponentLayerBaseAnimationToLong) {
            CABasicAnimation *animation = [self scaleXAnimationDuration:[TABAnimated sharedAnimated].classicAnimation.duration toValue:[TABAnimated sharedAnimated].classicAnimation.longToValue];
            [layer addAnimation:animation forKey:kAnimatedClassicAnimation];
        }if (layer.baseAnimationType == TABComponentLayerBaseAnimationToShort) {
            CABasicAnimation *animation = [self scaleXAnimationDuration:[TABAnimated sharedAnimated].classicAnimation.duration toValue:[TABAnimated sharedAnimated].classicAnimation.shortToValue];
            [layer addAnimation:animation forKey:kAnimatedClassicAnimation];
        }
    }
}

- (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration toValue:(CGFloat)toValue {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.toValue = (toValue == 0.)? @0.6 : @(toValue);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end
