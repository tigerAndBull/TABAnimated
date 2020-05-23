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
#import "TABComponentLayerBindClassicImpl.h"
#import "TABComponentLayerBindDropImpl.h"

@implementation TABViewAnimated

- (instancetype)init {
    if (self = [super init]) {
        _superAnimationType = TABViewSuperAnimationTypeDefault;
        _filterSubViewSize = CGSizeZero;
        _producter = TABAnimatedProductImpl.new;
        
        [self _initBinder];
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

- (void)_initBinder {
    if (self.superAnimationType == TABViewSuperAnimationTypeDefault) {
        switch ([TABAnimated sharedAnimated].animationType) {
            case TABAnimationTypeDrop: {
                _binder = TABComponentLayerBindDropImpl.new;
            }
                break;
            default: {
                _binder = TABComponentLayerBindClassicImpl.new;
            }
                break;
        }
    }else if(self.superAnimationType == TABViewSuperAnimationTypeDrop) {
        _binder = TABComponentLayerBindDropImpl.new;
    }else {
        _binder = TABComponentLayerBindClassicImpl.new;
    }
}

#pragma mark -

- (void)setSuperAnimationType:(TABViewSuperAnimationType)superAnimationType {
    _superAnimationType = superAnimationType;
    [self _initBinder];
}

- (CGFloat)animatedHeight {
    if (_animatedHeight > 0.) {
        return _animatedHeight;
    }
    return [TABAnimated sharedAnimated].animatedHeight;
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
