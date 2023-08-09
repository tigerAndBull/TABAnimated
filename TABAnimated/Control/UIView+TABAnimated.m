//
//  UIView+TABAnimated.m
//  TABAnimatedDemo
//
//  Created by wenhuan on 2021/4/27.
//  Copyright © 2021 tigerAndBull. All rights reserved.
//

#import "UIView+TABAnimated.h"
#import <objc/runtime.h>

@implementation UIView (TABAnimated)

- (NSString *)tab_name {
    return objc_getAssociatedObject(self, @selector(tab_name));
}

- (void)setTab_name:(NSString *)tab_name {
    objc_setAssociatedObject(self, @selector(tab_name), tab_name, OBJC_ASSOCIATION_COPY);
}

@end
