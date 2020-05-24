//
//  TABBaseComponent+TABDropAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/19.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABBaseComponent+TABDropAnimation.h"
#import "TABComponentLayer+TABDropAnimation.h"

@implementation TABBaseComponent (TABDropAnimation)

- (TABBaseComponentIntegerBlock)dropIndex {
    return ^TABBaseComponent *(NSInteger value) {
        [self result_dropIndex:value];
        return self;
    };
}

- (void)preview_dropIndex:(NSNumber *)number {
    [self result_dropIndex:[number integerValue]];
}

- (void)result_dropIndex:(NSInteger)value {
    self.layer.dropAnimationIndex = value;
}

#pragma mark - dropFromIndex

- (TABBaseComponentIntegerBlock)dropFromIndex {
    return ^TABBaseComponent *(NSInteger value) {
        [self result_dropFromIndex:value];
        return self;
    };
}

- (void)preview_dropFromIndex:(NSNumber *)number {
    [self result_dropFromIndex:[number integerValue]];
}

- (void)result_dropFromIndex:(NSInteger)value {
    self.layer.dropAnimationFromIndex = value;
}

#pragma mark - removeOnDrop

- (TABBaseComponentVoidBlock)removeOnDrop {
    return ^TABBaseComponent *(void) {
        [self result_removeOnDrop];
        return self;
    };
}

- (void)preview_removeOnDrop {
    [self result_removeOnDrop];
}

- (void)result_removeOnDrop {
    self.layer.removeOnDropAnimation = YES;
}

#pragma mark - dropStayTime

- (TABBaseComponentFloatBlock)dropStayTime {
    return ^TABBaseComponent *(CGFloat value) {
        [self result_dropStayTime:value];
        return self;
    };
}

- (void)preview_dropStayTime:(NSNumber *)number {
    [self result_dropStayTime:[number floatValue]];
}

- (void)result_dropStayTime:(CGFloat)value {
    self.layer.dropAnimationStayTime = value;
}

@end
