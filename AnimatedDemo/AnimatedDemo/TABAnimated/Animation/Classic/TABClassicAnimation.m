//
//  TABClassicAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/5/4.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABClassicAnimation.h"

@implementation TABClassicAnimation

- (instancetype)init {
    if (self = [super init]) {
        _duration = 0.7;
        _longToValue = 1.9;
        _shortToValue = 0.6;
    }
    return self;
}

@end
