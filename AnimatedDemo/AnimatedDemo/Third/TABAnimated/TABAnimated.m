//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimated.h"

#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

#import "UIView+TABAnimated.h"
#import "UITableView+TABAnimated.h"
#import "UICollectionView+TABAnimated.h"

#import <objc/runtime.h>

@implementation TABAnimated

#pragma mark - Getter

- (CGFloat)animatedHeightCoefficient {
    if (_animatedHeightCoefficient == 0.) {
        return 0.75f;
    }
    return _animatedHeightCoefficient;
}

- (CGFloat)animatedHeight {
    if (_animatedHeight == 0.) {
        return 12.f;
    }
    return _animatedHeight;
}

- (UIColor *)animatedBackgroundColor {
    if (_animatedBackgroundColor) {
        return _animatedBackgroundColor;
    }
    return UIColor.whiteColor;
}

- (UIColor *)dropAnimationDeepColor {
    if (_dropAnimationDeepColor) {
        return _dropAnimationDeepColor;
    }
    return tab_kColor(0xE1E1E1FF);
}

- (CGFloat)dropAnimationDuration {
    if (_dropAnimationDuration) {
        return _dropAnimationDuration;
    }
    return 0.4;
}

- (CGFloat)animatedDuration {
    if (_animatedDuration == 0) {
        return 0.7;
    }
    return _animatedDuration;
}

- (CGFloat)animatedDurationBin {
    if (_animatedDurationBin == 0.) {
        return 1.0;
    }
    return _animatedDurationBin;
}

- (CGFloat)longToValue {
    if (_longToValue == 0) {
        return 1.9;
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

+ (TABAnimated *)sharedAnimated {
    
    static TABAnimated *tabAnimated;
    
    if (nil == tabAnimated) {
        tabAnimated = [[TABAnimated alloc] init];
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

- (void)initWithDropAnimated {
    if (self) {
        _animationType = TABAnimationTypeDrop;
        _animatedColor = tab_kBackColor;
    }
}

@end
