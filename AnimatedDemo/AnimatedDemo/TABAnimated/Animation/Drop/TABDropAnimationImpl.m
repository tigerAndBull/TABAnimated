//
//  TABDropAnimationImpl.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/20.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABDropAnimationImpl.h"

#import "TABComponentLayer+TABDropAnimation.h"
#import "TABBaseComponent+TABDropAnimation.h"

#import "TABDropAnimation.h"
#import "TABAnimatedDarkModeInterface.h"

static NSString * const kAnimatedDropAnimation = @"kAnimatedDropAnimation";

@implementation TABDropAnimationImpl

+ (instancetype)dropWithAnimation:(TABDropAnimation *)dropAnimation {
    TABDropAnimationImpl *dropAnimationImpl = [[TABDropAnimationImpl alloc] initWithAnimation:dropAnimation];
    return dropAnimationImpl;
}

- (instancetype)initWithAnimation:(TABDropAnimation *)dropAnimation {
    if (self = [super init]) {
        _dropAnimation = dropAnimation;
    }
    return self;
}

#pragma mark - TABAnimatedDecorateInterface

- (void)propertyBindingWithBackgroundLayer:(TABComponentLayer *)backgroundLayer {
    
}

- (void)propertyBindingWithLayer:(TABComponentLayer *)layer index:(NSInteger)index {
    
}

- (void)addAnimationWithTraitCollection:(UITraitCollection *)traitCollection
                        backgroundLayer:(TABComponentLayer *)backgroundLayer
                                 layers:(NSArray <TABComponentLayer *> *)layers {
    
    UIColor *deepColor;
    if (@available(iOS 12.0, *)) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            deepColor = self.dropAnimation.dropAnimationDeepColorInDarkMode;
        }else {
            deepColor = self.dropAnimation.dropAnimationDeepColor;
        }
    } else {
        deepColor = self.dropAnimation.dropAnimationDeepColor;
    }
    
    if (deepColor == nil) return;
    
    CGFloat duration = duration = self.dropAnimation.dropAnimationDuration;
    CGFloat cutTime = 0.02;
    CGFloat allCutTime = cutTime*(layers.count-1)*(layers.count)/2.0;
    NSInteger dropAnimationCount = layers.count;
    
    for (NSInteger i = 0; i < layers.count; i++) {
        TABComponentLayer *layer = layers[i];
        if (layer.removeOnDropAnimation || layer.withoutAnimation) continue;
        [self _addDropAnimation:layer
                          index:layer.dropAnimationIndex
                       duration:duration*(dropAnimationCount+1)-allCutTime
                          count:dropAnimationCount+1
                       stayTime:layer.dropAnimationStayTime-i*cutTime
                      deepColor:deepColor];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)traitCollection
                     tabAnimated:(TABViewAnimated *)tabAnimated
                 backgroundLayer:(TABComponentLayer *)backgroundLayer
                          layers:(NSArray <TABComponentLayer *> *)layers {
    
    UIColor *deepColor;
    if (@available(iOS 12.0, *)) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            deepColor = self.dropAnimation.dropAnimationDeepColorInDarkMode;
        }else {
            deepColor = self.dropAnimation.dropAnimationDeepColor;
        }
    } else {
        deepColor = self.dropAnimation.dropAnimationDeepColor;
    }
    
    for (TABComponentLayer *layer in layers) {
        if ([layer animationForKey:kAnimatedDropAnimation]) {
            CAKeyframeAnimation *animation = [layer animationForKey:kAnimatedDropAnimation].copy;
            animation.values = @[
                                 (id)deepColor.CGColor,
                                 (id)layer.backgroundColor,
                                 (id)layer.backgroundColor,
                                 (id)deepColor.CGColor
                                 ];
            [layer removeAnimationForKey:kAnimatedDropAnimation];
            [layer addAnimation:animation forKey:kAnimatedDropAnimation];
        }
    }
}

#pragma mark - Private

- (void)_addDropAnimation:(CALayer *)layer index:(NSInteger)index duration:(CGFloat)duration count:(NSInteger)count stayTime:(CGFloat)stayTime deepColor:(UIColor *)deepColor {
    
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
    [layer addAnimation:animation forKey:kAnimatedDropAnimation];
}

- (TABDropAnimation *)dropAnimation {
    if (!_dropAnimation) {
        return [TABAnimated sharedAnimated].dropAnimation;
    }
    return _dropAnimation;
}

@end
