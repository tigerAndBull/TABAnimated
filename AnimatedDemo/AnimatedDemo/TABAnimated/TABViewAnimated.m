//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"

#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UICollectionView+Animated.h"

#import <objc/runtime.h>

//static CGFloat defaultDuration = 0.5f;

@implementation TABViewAnimated

#pragma mark - Getter

- (CGFloat)animatedHeightCoefficient {
    if (_animatedHeightCoefficient == 0.) {
        return 0.75f;
    }
    return _animatedHeightCoefficient;
}

#pragma mark - Initize Method

+ (TABViewAnimated *)sharedAnimated {
    
    static TABViewAnimated *tabAnimated;
    
    if (nil == tabAnimated) {
        tabAnimated = [[TABViewAnimated alloc] init];
    }
    return tabAnimated;
}

- (instancetype)init {
    if (self = [super init]) {
        _animationType = TABAnimationTypeOnlySkeleton;
    }
    return self;
}

- (void)initWithOnlySkeleton {
    if (self) {
        _animationType = TABAnimationTypeOnlySkeleton;
        _animatedColor = tab_kBackColor;
    }
}

- (void)initWithBinAnimation {
    if (self) {
        _animationType = TABAnimationTypeBinAnimation;
        _animatedColor = tab_kBackColor;
    }
}

- (void)initWithShimmerAnimated {
    if (self) {
        _animationType = TABAnimationTypeShimmer;
        _animatedDurationShimmer = 1.5f;
        _animatedColor = tab_kBackColor;
    }
}

- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color {
    if (self) {
        _animatedDurationShimmer = duration;
        _animatedColor = color;
        _animationType = TABAnimationTypeShimmer;
    }
}

@end
