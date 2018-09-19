//
//  UIView+Animated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+Animated.h"
#import <objc/runtime.h>

@implementation UIView (Animated)

- (TABViewLoadAnimationStyle)loadStyle {
    NSNumber *value = objc_getAssociatedObject(self, @selector(loadStyle));
    return value.intValue;
}

- (void)setLoadStyle:(TABViewLoadAnimationStyle)loadStyle {
    objc_setAssociatedObject(self, @selector(loadStyle), @(loadStyle), OBJC_ASSOCIATION_ASSIGN);
}

@end
