//
//  TABBaseComponent+TABClassicAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/24.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABBaseComponent+TABClassicAnimation.h"
#import "TABComponentLayer+TABClassicAnimation.h"

@implementation TABBaseComponent (TABClassicAnimation)

#pragma mark - toLongAnimation

- (TABBaseComponentVoidBlock)toLongAnimation {
    return ^TABBaseComponent *(void) {
        [self result_toLongAnimation];
        return self;
    };
}

- (void)preview_toLongAnimation {
    [self result_toLongAnimation];
}

- (void)result_toLongAnimation {
    self.layer.baseAnimationType = TABComponentLayerBaseAnimationToLong;
}

#pragma mark - toShortAnimation

- (TABBaseComponentVoidBlock)toShortAnimation {
    return ^TABBaseComponent *(void) {
        [self result_toShortAnimation];
        return self;
    };
}

- (void)preview_toShortAnimation {
    [self result_toShortAnimation];
}

- (void)result_toShortAnimation {
    self.layer.baseAnimationType = TABComponentLayerBaseAnimationToShort;
}

@end
