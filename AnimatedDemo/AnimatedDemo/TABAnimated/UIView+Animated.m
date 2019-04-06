//
//  UIView+Animated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+Animated.h"
#import "TABViewAnimated.h"
#import "UIView+TABControlAnimation.h"
#import "TABAnimatedObject.h"
#import "TABLayer.h"

#import <objc/runtime.h>

@implementation UIView (Animated)

#pragma mark - Getter/Setter

- (TABViewLoadAnimationStyle)loadStyle {
    NSNumber *value = objc_getAssociatedObject(self, @selector(loadStyle));
    return value.intValue;
}

- (void)setLoadStyle:(TABViewLoadAnimationStyle)loadStyle {
    objc_setAssociatedObject(self, @selector(loadStyle), @(loadStyle), OBJC_ASSOCIATION_ASSIGN);
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

- (TABAnimatedObject *)tabAnimated {
    return objc_getAssociatedObject(self, @selector(tabAnimated));
}

- (void)setTabAnimated:(TABAnimatedObject *)tabAnimated {
    objc_setAssociatedObject(self, @selector(tabAnimated),tabAnimated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABLayer *)tabLayer {
    return objc_getAssociatedObject(self, @selector(tabLayer));
}

- (void)setTabLayer:(TABLayer *)tabLayer {
    objc_setAssociatedObject(self, @selector(tabLayer),tabLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
