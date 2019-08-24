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
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.removedOnCompletion = NO;
    animation.duration = duration;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    animation.toValue = (toValue == 0.)?@0.6:@(toValue);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.1f];
    animation.toValue = [NSNumber numberWithFloat:0.6f];
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [view.layer addAnimation:animation forKey:key];
}

+ (void)addShimmerAnimationToLayer:(CALayer *)layer
                          duration:(CGFloat)duration
                               key:(NSString *)key
                         direction:(TABShimmerDirection)direction {
    
    TABShimmerTransition startPointTransition = transitionMaker(direction, TABShimmerPropertyStartPoint);
    TABShimmerTransition endPointTransition = transitionMaker(direction, TABShimmerPropertyEndPoint);
    
    CABasicAnimation *startPointAnim = [CABasicAnimation animationWithKeyPath:@"startPoint"];
    startPointAnim.fromValue = [NSValue valueWithCGPoint:startPointTransition.startValue];
    startPointAnim.toValue = [NSValue valueWithCGPoint:startPointTransition.endValue];
    
    CABasicAnimation *endPointAnim = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    endPointAnim.fromValue = [NSValue valueWithCGPoint:endPointTransition.startValue];
    endPointAnim.toValue = [NSValue valueWithCGPoint:endPointTransition.endValue];
    
    CAAnimationGroup *animGroup = [[CAAnimationGroup alloc] init];
    animGroup.animations = @[startPointAnim, endPointAnim];
    animGroup.duration = duration;
    animGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animGroup.repeatCount = HUGE_VALF;
    animGroup.removedOnCompletion = NO;
    
    [layer addAnimation:animGroup forKey:key];
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

+ (void)addEaseOutAnimation:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.2;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionFade;
    [view.layer addAnimation:animation forKey:@"animation"];
}

static TABShimmerTransition transitionMaker(TABShimmerDirection dir, TABShimmerProperty position) {
    
    if (dir == TABShimmerDirectionToLeft) {
        TABShimmerTransition transition;
        if (position == TABShimmerPropertyStartPoint) {
            transition.startValue = CGPointMake(1, 0.5);
            transition.endValue = CGPointMake(-1, 0.5);
        }else {
            transition.startValue = CGPointMake(2, 0.5);
            transition.endValue = CGPointMake(0, 0.5);
        }
        
        return transition;
    }
    
    TABShimmerTransition transition;
    if (position == TABShimmerPropertyStartPoint) {
        transition.startValue = CGPointMake(-1, 0.5);
        transition.endValue = CGPointMake(1, 0.5);
    }else {
        transition.startValue = CGPointMake(0, 0.5);
        transition.endValue = CGPointMake(2, 0.5);
    }
    
    return transition;
}

@end
