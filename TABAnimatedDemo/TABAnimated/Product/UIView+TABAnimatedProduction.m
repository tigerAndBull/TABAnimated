//
//  UIView+Animated.m
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABAnimatedProduction.h"
#import <objc/runtime.h>
#import "TABAnimatedProduction.h"

@implementation UIView (TABAnimatedProduction)

- (TABAnimatedProduction *)tabAnimatedProduction {
    return objc_getAssociatedObject(self, @selector(tabAnimatedProduction));
}

- (void)setTabAnimatedProduction:(TABAnimatedProduction *)tabAnimatedProduction {
    objc_setAssociatedObject(self, @selector(tabAnimatedProduction), tabAnimatedProduction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

