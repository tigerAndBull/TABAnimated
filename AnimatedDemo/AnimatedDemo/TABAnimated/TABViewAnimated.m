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

static CGFloat defaultDuration = 0.6f;

@implementation TABViewAnimated

#pragma mark - Getter

- (CGFloat)animatedHeightCoefficient {
    if (_animatedHeightCoefficient == 0) {
        return 0.75f;
    }
    return _animatedHeightCoefficient;
}

- (CGFloat)longToValue {
    if (_longToValue == 0) {
        return 1.4;
    }
    return _longToValue;
}

- (CGFloat)shortToValue {
    if (_shortToValue == 0) {
        return 0.6;
    }
    return _shortToValue;
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
        _animationType = TABAnimationTypeDefault;
    }
    return self;
}

- (void)initWithDefaultAnimated {
    if (self) {
        _animatedDuration = defaultDuration;
        _animatedColor = tab_kBackColor;
        _animationType = TABAnimationTypeDefault;
    }
}

- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color {
    if (self) {
        _animatedDuration = duration;
        _animatedColor = color;
        _animationType = TABAnimationTypeDefault;
    }
}

- (void)initWithAnimatedDuration:(CGFloat)duration
                       withColor:(UIColor *)color
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue {
    if (self) {
        _animatedDuration = duration;
        _animatedColor = color;
        _shortToValue = shortToValue;
        _longToValue = longToValue;
        _animationType = TABAnimationTypeDefault;
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

- (void)initWithOnlySkeleton {
    if (self) {
        _animationType = TABAnimationTypeOnlySkeleton;
        _animatedColor = tab_kBackColor;
    }
}

- (void)initWithCustomAnimation {
    if (self) {
        _animationType = TABAnimationTypeCustom;
        _animatedDurationShimmer = 1.5f;
        _animatedDuration = defaultDuration;
    }
}

- (void)initWithDefaultDurationAnimation:(CGFloat)defaultAnimationDuration
                 withLongToValue:(CGFloat)longToValue
                withShortToValue:(CGFloat)shortToValue
    withShimmerAnimationDuration:(CGFloat)shimmerAnimationDuration
                       withColor:(UIColor *)color {
    if (self) {
        _animationType = TABAnimationTypeCustom;
        _animatedDurationShimmer = shimmerAnimationDuration;
        _animatedDuration = defaultAnimationDuration;
        _animatedColor = color;
        _shortToValue = shortToValue;
        _longToValue = longToValue;
    }
}

@end
