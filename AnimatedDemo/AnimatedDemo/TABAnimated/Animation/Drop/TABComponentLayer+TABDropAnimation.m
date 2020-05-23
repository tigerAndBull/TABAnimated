//
//  TABComponentLayer+TABDropLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/19.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer+TABDropAnimation.h"
#import <objc/runtime.h>

@implementation TABComponentLayer (TABDropAnimation)

- (void)setDropAnimationIndex:(NSInteger)dropAnimationIndex {
    objc_setAssociatedObject(self, @selector(dropAnimationIndex), @(dropAnimationIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dropAnimationIndex {
    return [objc_getAssociatedObject(self, @selector(dropAnimationIndex)) integerValue];
}

- (void)setDropAnimationFromIndex:(NSInteger)dropAnimationFromIndex {
    objc_setAssociatedObject(self, @selector(dropAnimationFromIndex), @(dropAnimationFromIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)dropAnimationFromIndex {
    return [objc_getAssociatedObject(self, @selector(dropAnimationFromIndex)) integerValue];
}

- (void)setDropAnimationStayTime:(CGFloat)dropAnimationStayTime {
    objc_setAssociatedObject(self, @selector(dropAnimationStayTime), @(dropAnimationStayTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)dropAnimationStayTime {
    return [objc_getAssociatedObject(self, @selector(dropAnimationStayTime)) floatValue];
}

- (void)setRemoveOnDropAnimation:(BOOL)removeOnDropAnimation {
    objc_setAssociatedObject(self, @selector(removeOnDropAnimation), @(removeOnDropAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)removeOnDropAnimation {
    return [objc_getAssociatedObject(self, @selector(removeOnDropAnimation)) boolValue];
}

@end
