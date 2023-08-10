//
//  TABBinAnimationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/20.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABBinAnimationImpl.h"
#import "TABBinAnimation.h"
#import "TABComponentLayer.h"
#import "TABAnimated.h"

static NSString * const kAnimatedBinAnimation = @"kAnimatedBinAnimation";

@implementation TABBinAnimationImpl

- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray<TABComponentLayer *> *)layers {
    [self _addBinAnimationWithLayer:backgroundLayer duration:[TABAnimated sharedAnimated].binAnimation.animatedDurationBin key:kAnimatedBinAnimation];
}

- (void)_addBinAnimationWithLayer:(CALayer *)layer
                         duration:(CGFloat)duration
                              key:(NSString *)key {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.1];
    animation.toValue = [NSNumber numberWithFloat:0.6];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:key];
}

- (void)destory {
    
}

@end
