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

#import "TABComponentLayerDropSerializationImpl.h"
#import "TABComponentLayerClassicSerializationImpl.h"

@implementation TABViewAnimated

NSString *tab_NSStringFromClass(Class aClass) {
    NSString *classString = NSStringFromClass(aClass);
    if ([classString containsString:@"."]) {
        NSRange range = [classString rangeOfString:@"."];
        classString = [classString substringFromIndex:range.location+1];
    }
    return classString;
}

- (instancetype)initWithViewHeight:(CGFloat)viewHeight {
    if (self = [self init]) {
        _viewHeight = viewHeight;
    }
    return self;
}

+ (instancetype)animatedWithViewHeight:(CGFloat)viewHeight {
    TABViewAnimated *tabAnimated = [[TABViewAnimated alloc] initWithViewHeight:viewHeight];
    return tabAnimated;
}

- (instancetype)init {
    if (self = [super init]) {
        _superAnimationType = TABViewSuperAnimationTypeDefault;
        _filterSubViewSize = CGSizeZero;
        _producter = TABAnimatedProductImpl.new;
        
        [self _initSeriaSlizationImpl];
    }
    return self;
}

- (BOOL)isAnimating {
    if (self.state == TABViewAnimationStart ||
        self.state == TABViewAnimationRunning) {
        return YES;
    }
    return NO;
}

- (BOOL)currentIndexIsAnimatingWithIndex:(NSInteger)index {
    return YES;
}

- (nonnull UIColor *)getCurrentAnimatedColorWithCollection:(UITraitCollection *)collection {
    if ([TABAnimated sharedAnimated].darkModeType == TABAnimatedDarkModeForceDark) {
        return self.darkAnimatedColor;
    }else if ([TABAnimated sharedAnimated].darkModeType == TABAnimatedDarkModeForceNormal) {
        return self.animatedColor;
    }
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
    if ([TABAnimated sharedAnimated].darkModeType == TABAnimatedDarkModeForceDark) {
        return self.darkAnimatedBackgroundColor;
    }else if ([TABAnimated sharedAnimated].darkModeType == TABAnimatedDarkModeForceNormal) {
        return self.animatedBackgroundColor;
    }
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

- (void)_initSeriaSlizationImpl {
    if (self.superAnimationType == TABViewSuperAnimationTypeDefault) {
        switch ([TABAnimated sharedAnimated].animationType) {
            case TABAnimationTypeDrop: {
                _serializationImpl = TABComponentLayerDropSerializationImpl.new;
            }
                break;
            default: {
                _serializationImpl = TABComponentLayerClassicSerializationImpl.new;
            }
                break;
        }
    }else if(self.superAnimationType == TABViewSuperAnimationTypeDrop) {
        _serializationImpl = TABComponentLayerDropSerializationImpl.new;
    }else {
        _serializationImpl = TABComponentLayerClassicSerializationImpl.new;
    }
}

#pragma mark -

- (void)setSuperAnimationType:(TABViewSuperAnimationType)superAnimationType {
    _superAnimationType = superAnimationType;
    [self _initSeriaSlizationImpl];
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
