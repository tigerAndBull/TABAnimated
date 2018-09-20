//
//  UIView+AnimatedStyle.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/20.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+AnimatedStyle.h"
#import <objc/runtime.h>

@implementation UIView (AnimatedStyle)

- (TABViewAnimationStyle)animatedStyle {
    
    NSNumber *value = objc_getAssociatedObject(self, @selector(animatedStyle));
    return value.intValue;
}

- (void)setAnimatedStyle:(TABViewAnimationStyle)animatedStyle {
    
    objc_setAssociatedObject(self, @selector(animatedStyle), @(animatedStyle), OBJC_ASSOCIATION_ASSIGN);
}

@end
