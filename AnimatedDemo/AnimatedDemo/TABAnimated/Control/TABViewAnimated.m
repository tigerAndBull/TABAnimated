//
//  TABBaseAnimated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/4/27.
//  Copyright © 2019 tigerAndBull. All rights reserved.
//

#import "TABViewAnimated.h"
#import "TABAnimated.h"

#import "TABAnimatedProductImpl.h"

const NSInteger TABViewAnimatedErrorCode = -1000;

NSString * const TABViewAnimatedHeaderPrefixString = @"tab_header_";
NSString * const TABViewAnimatedFooterPrefixString = @"tab_footer_";
NSString * const TABViewAnimatedDefaultSuffixString = @"default_resuable_view";

@implementation TABViewAnimated

- (instancetype)init {
    if (self = [super init]) {
        _superAnimationType = TABViewSuperAnimationTypeDefault;
        _filterSubViewSize = CGSizeZero;
        _producter = TABAnimatedProductImpl.new;
    }
    return self;
}

- (BOOL)currentIndexIsAnimatingWithIndex:(NSInteger)index {
    return YES;
}

- (nonnull UIColor *)getCurrentAnimatedColorWithCollection:(UITraitCollection *)collection {
    if (@available(iOS 13.0, *)) {
        if (collection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return self.darkAnimatedColor;
        }else {
            return self.animatedColor;
        }
    }else {
        return self.animatedColor;
    }
}

- (nonnull UIColor *)getCurrentAnimatedBackgroundColorWithCollection:(UITraitCollection *)collection {
    if (@available(iOS 13.0, *)) {
        if (collection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return self.darkAnimatedBackgroundColor;
        }else {
            return self.animatedBackgroundColor;
        }
    }else {
        return self.animatedBackgroundColor;
    }
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
