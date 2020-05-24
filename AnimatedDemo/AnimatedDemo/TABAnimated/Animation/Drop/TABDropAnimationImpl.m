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
#import "TABAnimated.h"

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

- (instancetype)init {
    if (self = [super init]) {
        _dropAnimation = [TABAnimated sharedAnimated].dropAnimation;
    }
    return self;
}

#pragma mark - TABAnimatedDecorateInterface

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
    
    CGFloat duration = self.dropAnimation.dropAnimationDuration;
    CGFloat cutTime = 0.02;
    NSInteger dropAnimationCount = 0;
    
    for (TABComponentLayer *layer in layers) {
        if (layer.loadStyle == TABViewLoadAnimationRemove || layer.removeOnDropAnimation || layer.withoutAnimation) {
            continue;
        }
        if (layer.lineLayers.count > 0) {
            dropAnimationCount += layer.lineLayers.count;
            continue;
        }
        dropAnimationCount++;
    }
    dropAnimationCount++;
    
    CGFloat allCutTime = cutTime*(dropAnimationCount-1)*(dropAnimationCount)/2.0;
    CGFloat resultDuration = duration*(dropAnimationCount+1)-allCutTime;
    
    for (NSInteger i = 0; i < layers.count; i++) {
        TABComponentLayer *layer = layers[i];
        if (layer.loadStyle == TABViewLoadAnimationRemove || layer.removeOnDropAnimation || layer.withoutAnimation) {
            continue;
        }
        if (layer.lineLayers.count > 0) {
            for (NSInteger i = 0; i < layer.lineLayers.count; i++) {
                TABComponentLayer *sub = layer.lineLayers[i];
                sub.dropAnimationIndex = layer.dropAnimationFromIndex+i;
                [self _addDropAnimation:sub
                                  index:sub.dropAnimationIndex
                               duration:resultDuration
                                  count:dropAnimationCount
                               stayTime:(layer.dropAnimationStayTime == 0.) ? 0.2 : layer.dropAnimationStayTime  -i*cutTime
                              deepColor:deepColor];
            }
            continue;
        }
        [self _addDropAnimation:layer
                          index:layer.dropAnimationIndex
                       duration:resultDuration
                          count:dropAnimationCount
                       stayTime:(layer.dropAnimationStayTime == 0.) ? 0.2 : layer.dropAnimationStayTime  -i*cutTime
                      deepColor:deepColor];
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

        UIColor *animatedColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return tabAnimated.darkAnimatedColor;
            }else {
                return tabAnimated.animatedColor;
            }
        }];
        
        backgroundLayer.backgroundColor = animatedBackgroundColor.CGColor;
        for (TABComponentLayer *layer in layers) {
            if (layer.lineLayers.count > 0) {
                for (TABComponentLayer *sub in layer.lineLayers) {
                    sub.backgroundColor = animatedColor.CGColor;
                }
            }else {
                layer.backgroundColor = animatedColor.CGColor;
                if (layer.contents && layer.placeholderName && layer.placeholderName.length > 0) {
                    layer.contents = (id)[UIImage imageNamed:layer.placeholderName].CGImage;
                }
            }
        }
    }
    
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
        
        if (layer.loadStyle == TABViewLoadAnimationRemove || layer.removeOnDropAnimation || layer.withoutAnimation) {
            continue;
        }
        
        if (layer.lineLayers.count > 0) {
            for (TABComponentLayer *sub in layer.lineLayers) {
                if ([sub animationForKey:kAnimatedDropAnimation]) {
                    CAKeyframeAnimation *animation = [sub animationForKey:kAnimatedDropAnimation].copy;
                    animation.values = @[
                                         (id)deepColor.CGColor,
                                         (id)sub.backgroundColor,
                                         (id)sub.backgroundColor,
                                         (id)deepColor.CGColor
                                         ];
                    [sub removeAnimationForKey:kAnimatedDropAnimation];
                    [sub addAnimation:animation forKey:kAnimatedDropAnimation];
                }
            }
        }else {
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
}

#pragma mark - Private

- (void)_addDropAnimation:(CALayer *)layer index:(NSInteger)index duration:(CGFloat)duration count:(NSInteger)count stayTime:(CGFloat)stayTime deepColor:(UIColor *)deepColor {
    
    if (deepColor == nil || layer.backgroundColor == nil) {
        return;
    }
    
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
