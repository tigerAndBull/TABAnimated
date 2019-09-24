//
//  TABAnimatedBall.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/9/7.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABAnimatedBall.h"

@implementation TABAnimatedBall

+ (TABAnimatedBall *)shared {
    static dispatch_once_t token;
    static TABAnimatedBall *ball;
    dispatch_once(&token, ^{
        ball = TABAnimatedBall.new;
    });
    return ball;
}

- (void)install {
    if (!_flowBall) {
        TABRevealFlowBall *ball = TABRevealFlowBall.new;
        _flowBall = ball;
        [ball makeKeyAndVisible];
    }
}

@end
