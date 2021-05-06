//
//  TABShimmerAnimationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/20.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABShimmerAnimationImpl.h"
#import "TABShimmerAnimation.h"
#import "TABAnimatedDarkModeInterface.h"
#import "TABAnimated.h"

static NSString * const kShimmerAnimationKey = @"kShimmerAnimationKey";

@implementation TABShimmerAnimationImpl

#pragma mark - TABAnimatedDecorateInterface

- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray <TABComponentLayer *> *)layers {
    UIColor *baseColor;
    CGFloat brigtness;
    
    if (@available(iOS 13.0, *)) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            baseColor = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBackColorInDarkMode;
            brigtness = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBrightnessInDarkMode;
        }else {
            baseColor = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBackColor;
            brigtness = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBrightness;
        }
    }else {
        baseColor = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBackColor;
        brigtness = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBrightness;
    }
    
    if (baseColor == nil) return;
         
    UIColor *resultBrightnessColor = [self _brightenedColor:baseColor brightness:brigtness];
    if (resultBrightnessColor == nil) return;

    NSArray *colors = @[
                        (id)baseColor.CGColor,
                        (id)resultBrightnessColor.CGColor,
                        (id)baseColor.CGColor
                       ];
    
    for (TABComponentLayer *layer in layers) {
        [self _addShimmerAnimationWithLayer:layer colors:colors];
        for (TABComponentLayer *sub in layer.lineLayers) {
            [self _addShimmerAnimationWithLayer:sub colors:colors];
        }
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)traitCollection
                     tabAnimated:(TABViewAnimated *)tabAnimated
                 backgroundLayer:(TABComponentLayer *)backgroundLayer
                          layers:(NSArray <TABComponentLayer *> *)layers {
    
    if (@available(iOS 13.0, *)) {
        
        UIColor *animatedBackgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return tabAnimated.darkAnimatedBackgroundColor;
            }else {
                return tabAnimated.animatedBackgroundColor;
            }
        }];
        backgroundLayer.backgroundColor = animatedBackgroundColor.CGColor;
        
        __block CGFloat brigtness = 0.;
        UIColor *baseColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                brigtness = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBrightnessInDarkMode;
                return [TABAnimated sharedAnimated].shimmerAnimation.shimmerBackColorInDarkMode;
            }else {
                brigtness = [TABAnimated sharedAnimated].shimmerAnimation.shimmerBrightness;
                return [TABAnimated sharedAnimated].shimmerAnimation.shimmerBackColor;
            }
        }];
       
        if (baseColor == nil) return;
       for (TABComponentLayer *layer in layers) {
           if (layer.colors && [layer animationForKey:kShimmerAnimationKey]) {
               layer.colors = @[(id)baseColor.CGColor, (id)[self _brightenedColor:baseColor brightness:brigtness].CGColor, (id)baseColor.CGColor];
           }
       }
    }
}

#pragma mark - Private

- (void)_addShimmerAnimationWithLayer:(TABComponentLayer *)layer colors:(NSArray *)colors {
    if(layer.withoutAnimation) return;
    layer.colors = colors;
    [layer removeAnimationForKey:kShimmerAnimationKey];
    [self _addShimmerAnimationToLayer:layer
                             duration:[TABAnimated sharedAnimated].shimmerAnimation.shimmerDuration
                            direction:[TABAnimated sharedAnimated].shimmerAnimation.shimmerDirection];
}

- (UIColor *)_brightenedColor:(UIColor *)color brightness:(CGFloat)brightness {
    CGFloat h,s,b,a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    return [UIColor colorWithHue:h saturation:s brightness:b*brightness alpha:a];
}

- (void)_addShimmerAnimationToLayer:(CALayer *)layer duration:(CGFloat)duration direction:(TABShimmerDirection)direction {
    
    TABShimmerTransition startPointTransition = _transitionMaker(direction, TABShimmerPropertyStartPoint);
    TABShimmerTransition endPointTransition = _transitionMaker(direction, TABShimmerPropertyEndPoint);
    
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
    [layer addAnimation:animGroup forKey:kShimmerAnimationKey];
}

static TABShimmerTransition _transitionMaker(TABShimmerDirection direction, TABShimmerProperty position) {
    
    if (direction == TABShimmerDirectionToLeft) {
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
