//
//  TABViewAnimated.m
//  TABAnimated
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimated.h"

#import "TABAnimatedConfig.h"
#import "TABAnimatedCacheManager.h"

@implementation TABAnimated

#pragma mark - Initize Method

+ (TABAnimated *)sharedAnimated {
    static dispatch_once_t token;
    static TABAnimated *tabAnimated;
    dispatch_once(&token, ^{
        tabAnimated = [[TABAnimated alloc] init];
    });
    return tabAnimated;
}

- (instancetype)initWithAnimatonType:(TABAnimationType)animationType {
    if (self = [super init]) {
        _animationType = animationType;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        _animationType = TABAnimationTypeOnlySkeleton;
        _animatedHeightCoefficient = 0.75;
        _scrollEnabled = YES;
        
        _animatedColor = tab_kBackColor;
        _darkAnimatedColor = tab_kDarkBackColor;
        
        _animatedBackgroundColor = UIColor.whiteColor;
        if (@available(iOS 13.0, *)) {
            _darkAnimatedBackgroundColor = UIColor.secondarySystemBackgroundColor;
        }else {
            _darkAnimatedBackgroundColor = UIColor.whiteColor;
        }
        
        _closeDiskCache = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TABAnimatedCacheManager shareManager] install];
        });
    }
    return self;
}

- (void)initWithOnlySkeleton {
    if (self) {
        _animationType = TABAnimationTypeOnlySkeleton;
    }
}

- (void)initWithBinAnimation {
    if (self) {
        _animationType = TABAnimationTypeBinAnimation;
    }
}

- (void)initWithShimmerAnimated {
    if (self) {
        _animationType = TABAnimationTypeShimmer;
    }
}

- (void)initWithShimmerAnimatedDuration:(CGFloat)duration
                              withColor:(UIColor *)color {
    if (self) {
        _animatedColor = color;
        _animationType = TABAnimationTypeShimmer;
    }
}

- (void)initWithDropAnimated {
    if (self) {
        _animationType = TABAnimationTypeDrop;
    }
}

#pragma mark - Getter / Setter

- (CGFloat)animatedHeight {
    
    if (!_useGlobalAnimatedHeight) {
        return 0.;
    }
    
    if (_animatedHeight == 0.) {
        return 12.f;
    }
    
    return _animatedHeight;
}

- (TABClassicAnimation *)classicAnimation {
    if (!_classicAnimation) {
        _classicAnimation = TABClassicAnimation.new;
    }
    return _classicAnimation;
}

- (TABShimmerAnimation *)shimmerAnimation {
    if (!_shimmerAnimation) {
        _shimmerAnimation = TABShimmerAnimation.new;
    }
    return _shimmerAnimation;
}

- (TABDropAnimation *)dropAnimation {
    if (!_dropAnimation) {
        _dropAnimation = TABDropAnimation.new;
    }
    return _dropAnimation;
}

- (TABBinAnimation *)binAnimation {
    if (!_binAnimation) {
        _binAnimation = TABBinAnimation.new;
    }
    return _binAnimation;
}

#pragma mark - Deprecated

- (CGFloat)animatedDuration {
    return self.classicAnimation.duration;
}
- (void)setAnimatedDuration:(CGFloat)animatedDuration {
    self.classicAnimation.duration = animatedDuration;
}
- (CGFloat)longToValue {
    return self.classicAnimation.longToValue;
}
- (void)setLongToValue:(CGFloat)longToValue {
    self.classicAnimation.longToValue = longToValue;
}
- (CGFloat)shortToValue {
    return self.classicAnimation.shortToValue;
}
- (void)setShortToValue:(CGFloat)shortToValue {
    self.classicAnimation.shortToValue = shortToValue;
}
- (CGFloat)animatedDurationBin {
    return self.binAnimation.animatedDurationBin;
}
- (void)setAnimatedDurationBin:(CGFloat)animatedDurationBin {
    self.binAnimation.animatedDurationBin = animatedDurationBin;
}
- (CGFloat)animatedDurationShimmer {
    return self.shimmerAnimation.shimmerDuration;
}
- (void)setAnimatedDurationShimmer:(CGFloat)animatedDurationShimmer {
    self.shimmerAnimation.shimmerDuration = animatedDurationShimmer;
}
- (TABShimmerDirection)shimmerDirection {
    return self.shimmerAnimation.shimmerDirection;
}
- (void)setShimmerDirection:(TABShimmerDirection)shimmerDirection {
    self.shimmerAnimation.shimmerDirection = shimmerDirection;
}
- (UIColor *)shimmerBackColor {
    return self.shimmerAnimation.shimmerBackColor;
}
- (void)setShimmerBackColor:(UIColor *)shimmerBackColor {
    self.shimmerAnimation.shimmerBackColor = shimmerBackColor;
}
- (CGFloat)shimmerBrightness {
    return self.shimmerAnimation.shimmerBrightness;
}
- (void)setShimmerBrightness:(CGFloat)shimmerBrightness {
    self.shimmerAnimation.shimmerBrightness = shimmerBrightness;
}
- (UIColor *)shimmerBackColorInDarkMode {
    return self.shimmerAnimation.shimmerBackColorInDarkMode;
}
- (void)setShimmerBackColorInDarkMode:(UIColor *)shimmerBackColorInDarkMode {
    self.shimmerAnimation.shimmerBackColorInDarkMode = shimmerBackColorInDarkMode;
}
- (CGFloat)shimmerBrightnessInDarkMode {
    return self.shimmerAnimation.shimmerBrightnessInDarkMode;
}
- (void)setShimmerBrightnessInDarkMode:(CGFloat)shimmerBrightnessInDarkMode {
    self.shimmerAnimation.shimmerBrightnessInDarkMode = shimmerBrightnessInDarkMode;
}

@end
