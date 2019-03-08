//
//  UIView+TABLayerout.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABLayoutSubviews.h"
#import "UIView+Animated.h"
#import "UIView+TABControlAnimation.h"

#import "TABViewAnimated.h"
#import "TABManagerMethod.h"
#import "TABManagerMethod+ManagerCALayer.h"
#import "TABAnimationMethod.h"

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

    // start animation/end animation
    dispatch_async(dispatch_get_main_queue(), ^{

        switch (self.animatedStyle) {
                
            case TABViewAnimationStart:

                // change status
                self.animatedStyle = TABViewAnimationRunning;
                
                // start animations
                if ([TABViewAnimated sharedAnimated].animationType != TABAnimationTypeCustom) {
                    [[TABManagerMethod sharedManager] cacheView:self];
                    [TABManagerMethod managerAnimationSubViewsOfView:self];
                }else {
                    if (self.superAnimationType != TABViewSuperAnimationTypeDefault) {
                        [[TABManagerMethod sharedManager] cacheView:self];
                        [TABManagerMethod managerAnimationSubViewsOfView:self];
                    }
                }

                // shimmer animations, UICollectionView be added by cell.
                if (![self isKindOfClass:[UICollectionView class]]) {
                    if (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) ||
                        ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeCustom && (self.superAnimationType == TABViewSuperAnimationTypeShimmer))) {
                        [TABAnimationMethod addShimmerAnimationToView:self
                                                             duration:[TABViewAnimated sharedAnimated].animatedDurationShimmer];
                    }
                }
                
                break;
                
            case TABViewAnimationEnd:

                // end animations
                [TABManagerMethod endAnimationToSubViews:self];
                [TABManagerMethod removeAllTABLayersFromView:self];
                [[TABManagerMethod sharedManager] recoverView:self];
                
                break;
                
            default:
                break;
        }
    });
}

@end
