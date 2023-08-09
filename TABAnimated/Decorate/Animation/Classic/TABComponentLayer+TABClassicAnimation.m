//
//  TABComponentLayer+TABClassicAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer+TABClassicAnimation.h"
#import <objc/runtime.h>

@implementation TABComponentLayer (TABClassicAnimation)

- (void)setBaseAnimationType:(TABComponentLayerBaseAnimationType)baseAnimationType {
    objc_setAssociatedObject(self, @selector(baseAnimationType), @(baseAnimationType), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TABComponentLayerBaseAnimationType)baseAnimationType {
    return [objc_getAssociatedObject(self, _cmd) intValue];
}

@end
