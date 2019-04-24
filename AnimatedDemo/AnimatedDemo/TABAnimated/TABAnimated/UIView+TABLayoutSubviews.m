//
//  UIView+TABLayerout.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABLayoutSubviews.h"
#import "UIView+TABControlAnimation.h"
#import "UIView+Animated.h"

#import "TABViewAnimated.h"
#import "TABManagerMethod.h"

#import "TABAnimationMethod.h"
#import "TABAnimatedObject.h"
#import "TABLayer.h"

#import <objc/runtime.h>

@implementation UIView (TABLayoutSubviews)

+ (void)load {
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        // Gets the layoutSubviews method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_layoutSubviews));
        
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_layoutSubviews {
    
    [self tab_layoutSubviews];

    if ([self isKindOfClass:[UITableView class]] ||
        [self isKindOfClass:[UICollectionView class]] ||
        [self isKindOfClass:[UICollectionViewCell class]] ||
        [self isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    
    // start animation/end animation
    dispatch_async(dispatch_get_main_queue(), ^{

        if (nil != self.tabAnimated) {
            
            switch (self.tabAnimated.state) {
                    
                case TABViewAnimationStart:
                    
                    // change status
                    self.tabAnimated.state = TABViewAnimationRunning;
                    
                    // start animations
                    [TABManagerMethod getNeedAnimationSubViews:self
                                                 withSuperView:self
                                                  withRootView:self];
                    
                    self.tabLayer.animatedBackgroundColor = self.tabAnimated.animatedBackgroundColor;
                    self.tabLayer.animatedColor = self.tabAnimated.animatedColor;
                    [self.tabLayer udpateSublayers];
                    
                    // add shimmer animation
                    if ([TABManagerMethod canAddShimmer:self]) {
                        [TABAnimationMethod addShimmerAnimationToView:self
                                                             duration:[TABViewAnimated sharedAnimated].animatedDurationShimmer];
                        break;
                    }
                    
                    // add bin animation
                    if ([TABManagerMethod canAddBinAnimation:self]) {
                        [TABAnimationMethod addAlphaAnimation:self];
                    }
                    
                    break;
                    
                case TABViewAnimationEnd:
                    
                    // end animations
                    [TABManagerMethod endAnimationToSubViews:self];
                    [TABManagerMethod removeMask:self];
                    
                    break;
                    
                default:
                    break;
            }
        }
    });
}

@end
