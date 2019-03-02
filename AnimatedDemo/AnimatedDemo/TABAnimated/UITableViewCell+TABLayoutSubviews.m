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
#import "TABManagerMethod+ManagerCALayer.h"
#import "TABAnimationMethod.h"

#import <objc/runtime.h>

@implementation UITableViewCell (TABLayoutSubviews)

+ (void)load {
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        
        // Gets the layoutSubviews method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_cell_layoutSubviews));
        
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
        
        if (superView != nil) {
            
            switch (superView.animatedStyle) {
                    
                case TABViewAnimationStart:
                    
                    // start animations
                    if ([TABViewAnimated sharedAnimated].animationType != TABAnimationTypeCustom) {
                        [[TABManagerMethod sharedManager] cacheView:self];
                        [self getNeedAnimationSubViews:self withSuperView:superView];
                    }else {
                        if (superView.superAnimationType != TABViewSuperAnimationTypeDefault) {
                            [[TABManagerMethod sharedManager] cacheView:self];
                            [self getNeedAnimationSubViews:self withSuperView:superView];
                        }
                    }
                    
                    break;
                    
                case TABViewAnimationEnd:
                    
                    // end animations
                    [TABManagerMethod endAnimationToSubViews:self];
                    [TABManagerMethod removeAllTABLayersFromView:self];
                    [[TABManagerMethod sharedManager] recoverView:self];
   
                default:
                    break;
            }
        }
    });
}

- (void)getNeedAnimationSubViews:(UIView *)view
                   withSuperView:(UIView *)superView {
    
    NSArray *subViews = [view subviews];
    if ([subViews count] == 0) {
        return;
    }
    
    for (int i = 0; i < subViews.count;i++) {
        
        UIView *subV = subViews[i];
        [self getNeedAnimationSubViews:subV withSuperView:subV.superview];
        
        if ([subV isKindOfClass:[UITableView class]]) {
            UITableView *view = (UITableView *)subV;
            subV.animatedStyle = TABViewAnimationStart;
            [view reloadData];
        }else {
            if ([subV isKindOfClass:[UICollectionView class]]) {
                UICollectionView *view = (UICollectionView *)subV;
                subV.animatedStyle = TABViewAnimationStart;
                [view reloadData];
            }
        }
        
        if (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) ||
            ([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeOnlySkeleton) ||
            (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeCustom) &&
             ((superView.superAnimationType == TABViewSuperAnimationTypeShimmer) ||
              (superView.superAnimationType == TABViewSuperAnimationTypeOnlySkeleton)))) {
                 
                 if ([subV.superview isKindOfClass:[UITableViewCell class]]) {
                     // used to can not add animation to contentView
                     if (i != 0) {
                         if (subV.loadStyle != TABViewLoadAnimationRemove) {
                             subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                         }
                     }
                 }else {
                     if (subV.loadStyle != TABViewLoadAnimationRemove) {
                         subV.loadStyle = TABViewLoadAnimationWithOnlySkeleton;
                     }
                 }
        }
        
        if ((subV.loadStyle != TABViewLoadAnimationDefault) && [TABManagerMethod judgeViewIsNeedAddAnimation:subV]) {
            [TABManagerMethod initLayerWithView:subV withSuperView:subV.superview withColor:[TABViewAnimated sharedAnimated].animatedColor];
        }

        if ([self.superview.superview isKindOfClass:[UITableViewCell class]] ||
            [self.superview.superview isKindOfClass:[UICollectionViewCell class]]||
            [self.superview.superview.superview isKindOfClass:[UITableViewCell class]]||
            [self.superview.superview.superview isKindOfClass:[UICollectionViewCell class]]) {
            
        }else {
            if (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeShimmer) ||
                (([TABViewAnimated sharedAnimated].animationType == TABAnimationTypeCustom) &&
                 (superView.superAnimationType == TABViewSuperAnimationTypeShimmer))) {
                    if (![subV.superview isKindOfClass:[UIButton class]]) {
                        if ([subV isEqual:[subViews lastObject]]) {
                            [TABAnimationMethod addShimmerAnimationToView:subV.superview
                                                                 duration:[TABViewAnimated sharedAnimated].animatedDurationShimmer];
                        }
                    }
                }
        }
    }
}

@end
