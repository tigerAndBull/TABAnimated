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
#import "TABMethod.h"

@implementation UIView (Animated)

#pragma mark -  Getter/Setter

- (TABViewLoadAnimationStyle)loadStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(loadStyle));
    return value.intValue;
}

- (void)setLoadStyle:(TABViewLoadAnimationStyle)loadStyle {
    
    objc_setAssociatedObject(self, @selector(loadStyle), @(loadStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (TABViewAnimationStyle)animatedStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedStyle));
    return value.intValue;
}

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {
    
    objc_setAssociatedObject(self, @selector(animatedStyle), @(animatedStyle), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)tabViewWidth {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(tabViewWidth));
    return value.floatValue;
}

- (void)setTabViewWidth:(CGFloat)tabViewWidth {
    
    objc_setAssociatedObject(self, @selector(tabViewWidth), @(tabViewWidth), OBJC_ASSOCIATION_ASSIGN);
}

@end
