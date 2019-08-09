//
//  UIView+TABLayerout.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABLayoutSubviews.h"
#import <objc/runtime.h>

@implementation UIView (TABLayoutSubviews)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // Gets the layoutSubviews method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_layoutSubviews));
        // Exchange
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_layoutSubviews {
    [self tab_layoutSubviews];
    
    // start animation/end animation
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self isKindOfClass:[UITableView class]] ||
            [self isKindOfClass:[UICollectionView class]]) {
            return;
        }
        
        UIView *superView = nil;
        
        if (([self isKindOfClass:[UICollectionReusableView class]] &&
             ![self isKindOfClass:[UICollectionViewCell class]]) ||
            ([self isKindOfClass:[UITableViewHeaderFooterView class]])) {
            
            if ([[[self superview] superview] isKindOfClass:[UITableView class]]) {
                superView = self.superview.superview;
            }else {
                superView = self.superview;
            }
            
            if (![superView isKindOfClass:[UICollectionView class]] &&
                ![superView isKindOfClass:[UITableView class]]) {
                return;
            }
            
            if (superView == nil ||
                superView.tabAnimated == nil ||
                !self.tabComponentManager) {
                return;
            }
            
            [TABManagerMethod runAnimationWithSuperView:superView
                                             targetView:self
                                                section:self.tabComponentManager.currentSection
                                                 isCell:YES
                                                manager:self.tabComponentManager];
            
        }
        
        if (nil != self.tabAnimated) {
            [TABManagerMethod runAnimationWithSuperView:self
                                             targetView:self
                                                section:self.tabComponentManager.currentSection
                                                 isCell:NO
                                                manager:self.tabComponentManager];
        }
    });
}

@end
