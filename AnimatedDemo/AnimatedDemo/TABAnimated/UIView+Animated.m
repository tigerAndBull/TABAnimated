//
//  UIView+Animated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+Animated.h"

#import <objc/runtime.h>

#import "TABViewAnimated.h"

@implementation UIView (Animated)

#pragma mark - Getter/Setter

- (TABViewLoadAnimationStyle)loadStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(loadStyle));
    return value.intValue;
}

- (void)setLoadStyle:(TABViewLoadAnimationStyle)loadStyle {
    
    objc_setAssociatedObject(self, @selector(loadStyle), @(loadStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (TABViewSuperAnimationType)superAnimationType {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(superAnimationType));
    return value.intValue;
}

- (void)setSuperAnimationType:(TABViewSuperAnimationType)superAnimationType {
    
    objc_setAssociatedObject(self, @selector(superAnimationType), @(superAnimationType), OBJC_ASSOCIATION_ASSIGN);
}

- (TABViewAnimationStyle)animatedStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedStyle));
    return value.intValue;
}

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {
    
    objc_setAssociatedObject(self, @selector(animatedStyle), @(animatedStyle), OBJC_ASSOCIATION_ASSIGN);
    if (animatedStyle == TABViewAnimationEnd) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self layoutSubviews];
        });
    }
}

- (float)tabViewWidth {
    return [objc_getAssociatedObject(self, @selector(tabViewWidth)) floatValue];
}

- (void)setTabViewWidth:(float)tabViewWidth {
    objc_setAssociatedObject(self, @selector(tabViewWidth), @(tabViewWidth), OBJC_ASSOCIATION_RETAIN);
}

- (float)tabViewHeight {
    return [objc_getAssociatedObject(self, @selector(tabViewHeight)) floatValue];
}

- (void)setTabViewHeight:(float)tabViewHeight {
    objc_setAssociatedObject(self, @selector(tabViewHeight), @(tabViewHeight), OBJC_ASSOCIATION_RETAIN);
}

@end
