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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (id)copyWithZone:(NSZone *)zone {
    TABComponentLayer *layer = [[[self class] allocWithZone:zone] init];
    
    layer.loadStyle = self.loadStyle;
    layer.origin  = self.origin;
    layer.numberOflines = self.numberOflines;
    layer.lineSpace = self.lineSpace;
    layer.lastScale = self.lastScale;
    layer.withoutAnimation = self.withoutAnimation;
    
    layer.dropAnimationIndex = self.dropAnimationIndex;
    layer.dropAnimationFromIndex = self.dropAnimationFromIndex;
    layer.removeOnDropAnimation = self.removeOnDropAnimation;
    layer.dropAnimationStayTime = self.dropAnimationStayTime;
    
    if (self.contents) layer.contents = self.contents;
    
    layer.placeholderName = self.placeholderName;
    layer.tagIndex = self.tagIndex;
    
    layer.frame = self.frame;
    layer.resultFrameValue = [NSValue valueWithCGRect:self.frame];
    layer.backgroundColor = self.backgroundColor;
    layer.shadowOffset = self.shadowOffset;
    layer.shadowColor = self.shadowColor;
    layer.shadowRadius = self.shadowRadius;
    layer.shadowOpacity = self.shadowOpacity;
    layer.cornerRadius = self.cornerRadius;
    layer.anchorPoint = self.anchorPoint;
    layer.position = self.position;
    layer.opaque = self.opaque;
    layer.contentsScale = self.contentsScale;
    
    return layer;
}
#pragma clang diagnostic pop

@end
