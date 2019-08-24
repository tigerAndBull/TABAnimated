//
//  UIView+TABLayerout.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UIView+TABLayoutSubviews.h"

#import "UIView+TABAnimated.h"
#import "TABViewAnimated.h"
#import "TABManagerMethod.h"
#import "TABComponentManager.h"

#import <objc/runtime.h>

@implementation UIView (TABLayoutSubviews)

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_layoutSubviews));
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
        
        // 获取当前视图类型
        UIView *superView = nil;
        
        // header / footer
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
            
            // header/footer 加载动画
            [TABManagerMethod runAnimationWithSuperView:superView
                                             targetView:self
                                                section:self.tabComponentManager.currentSection
                                                 isCell:YES
                                                manager:self.tabComponentManager];
            
        }
        
        // 普通view加载动画
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
