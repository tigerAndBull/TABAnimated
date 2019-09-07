//
//  TABComponentLayer.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/26.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABComponentLayer.h"

@implementation TABComponentLayer

- (instancetype)init {
    if (self = [super init]) {
        self.name = @"TABLayer";
        self.anchorPoint = CGPointMake(0, 0);
        self.position = CGPointMake(0, 0);
        self.opaque = YES;
        self.contentsGravity = kCAGravityResizeAspect;
        
        self.dropAnimationStayTime = 0.2;
        self.lastScale = 0.5;
        self.dropAnimationFromIndex = -1;
        self.dropAnimationIndex = -1;
        self.removeOnDropAnimation = NO;
    }
    return self;
}

- (CGFloat)lineSpace {
    if (_lineSpace == 0.) {
        return 8.;
    }
    return _lineSpace;
}

@end
