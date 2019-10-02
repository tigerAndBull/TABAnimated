//
//  TABBaseAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"
#import "TABAnimated.h"

const NSInteger TABViewAnimatedErrorCode = -1000;

NSString * const TABViewAnimatedHeaderPrefixString = @"tab_header_";
NSString * const TABViewAnimatedFooterPrefixString = @"tab_footer_";
NSString * const TABViewAnimatedDefaultSuffixString = @"default_resuable_view";

@implementation TABViewAnimated

- (instancetype)init {
    if (self = [super init]) {
        _animatedCountArray = @[].mutableCopy;
        _cellClassArray = @[].mutableCopy;
        _superAnimationType = TABViewSuperAnimationTypeDefault;
        _dropAnimationDuration = 0;
        _filterSubViewSize = CGSizeZero;
    }
    return self;
}

- (BOOL)currentIndexIsAnimatingWithIndex:(NSInteger)index {
    return YES;
}

- (UIColor *)animatedColor {
    if (_animatedColor) {
        return _animatedColor;
    }
    return [TABAnimated sharedAnimated].animatedColor;
}

- (UIColor *)animatedBackgroundColor {
    if (_animatedBackgroundColor) {
        return _animatedBackgroundColor;
    }
    return [TABAnimated sharedAnimated].animatedBackgroundColor;
}

- (UIColor *)darkAnimatedColor {
    if (_darkAnimatedColor) {
        return _darkAnimatedColor;
    }
    return [TABAnimated sharedAnimated].darkAnimatedColor;
}

- (UIColor *)darkAnimatedBackgroundColor {
    if (_darkAnimatedBackgroundColor) {
        return _darkAnimatedBackgroundColor;
    }
    return [TABAnimated sharedAnimated].darkAnimatedBackgroundColor;
}

@end
