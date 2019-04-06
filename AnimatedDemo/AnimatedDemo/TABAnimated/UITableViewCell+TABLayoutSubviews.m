//
//  UITableViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UITableViewCell+TABLayoutSubviews.h"
#import "UIView+Animated.h"
#import "UITableView+Animated.h"
#import "UIView+TABControlAnimation.h"

#import "TABViewAnimated.h"
#import "TABManagerMethod.h"
#import "TABAnimationMethod.h"

#import "TABAnimatedObject.h"
#import "TABLayer.h"

#import <objc/runtime.h>

@implementation UITableViewCell (TABLayoutSubviews)

+ (void)load {
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        // Gets the layoutSubviews method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_cell_layoutSubviews));
        // exchange
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_cell_layoutSubviews {
    [self tab_cell_layoutSubviews];
    
    // start/end animation.
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITableView *superView;
        // adapt to different ios versions.
        if ([[[self superview] superview] isKindOfClass:[UITableView class]]) {
            superView = (UITableView *)self.superview.superview;
        }else {
            superView = (UITableView *)self.superview;
        }
        
        switch (superView.tabAnimated.animatedStyle) {
                
            case TABViewAnimationStart:
                
                // start animations
                [TABManagerMethod getNeedAnimationSubViews:self
                                             withSuperView:superView
                                              withRootView:self];
                
                [self.tabLayer setNeedsDisplay];
                
                // add shimmer animation
                if ([TABManagerMethod canAddShimmer:self]) {
                    [TABAnimationMethod addShimmerAnimationToView:self
                                                         duration:[TABViewAnimated sharedAnimated].animatedDurationShimmer];
                    break;
                }
                
                if ([TABManagerMethod canAddBinAnimation:self]) {
                    [TABAnimationMethod addAlphaAnimation:self];
                }
                
                break;
                
            case TABViewAnimationEnd:
                
                // end animations
                [TABManagerMethod endAnimationToSubViews:self];
                [TABManagerMethod removeMask:self];
                
            default:
                break;
        }
    });
}

@end
