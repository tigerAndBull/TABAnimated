//
//  TABViewAnimated.m
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "TABAnimated.h"

#import "TABAnimatedDocumentMethod.h"
#import "TABAnimatedConfig.h"

#import <objc/runtime.h>
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
        _animatedColor = tab_kBackColor;
        _darkAnimatedColor = tab_kDarkBackColor;
        _animatedBackgroundColor = UIColor.whiteColor;
        if (@available(iOS 13.0, *)) {
            _darkAnimatedBackgroundColor =  UIColor.secondarySystemBackgroundColor;
        }else {
            _darkAnimatedBackgroundColor = UIColor.whiteColor;
        }
        
        [TABAnimatedDocumentMethod createFile:TABCacheManagerFolderName isDir:YES];
#ifdef DEBUG
        _closeCache = YES;
#endif
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
    if (_animatedHeight == 0.) {
        return 12.f;
    }
    return _animatedHeight;
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

@end
