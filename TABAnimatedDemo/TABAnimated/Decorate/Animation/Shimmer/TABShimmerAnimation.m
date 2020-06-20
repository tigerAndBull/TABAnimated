//
//  TABShimmerAnimation.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/12.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import "TABShimmerAnimation.h"

@implementation TABShimmerAnimation

- (instancetype)init {
    if (self = [super init]) {
        _shimmerBackColor = tab_kShimmerBackColor;
        _shimmerBackColorInDarkMode = tab_kDarkBackColor;
        
        _shimmerBrightness = 0.92;
        _shimmerBrightnessInDarkMode = 0.5;
        
        _shimmerDuration = 1.0;
    }
    return self;
}

@end
