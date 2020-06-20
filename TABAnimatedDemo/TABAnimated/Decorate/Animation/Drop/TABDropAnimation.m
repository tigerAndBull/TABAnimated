//
//  TABDropAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/12.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABDropAnimation.h"
#import "TABAnimatedConfig.h"

@implementation TABDropAnimation

- (instancetype)init {
    if (self = [super init]) {
        _dropAnimationDeepColor = tab_kColor(0xE1E1E1);
        _dropAnimationDeepColorInDarkMode = tab_kColor(0x323232);
        _dropAnimationDuration = 0.4;
    }
    return self;
}

@end
