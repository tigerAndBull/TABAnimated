//
//  UICollectionViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionViewCell+TABLayoutSubviews.h"
#import "UICollectionView+Animated.h"

#import "TABViewAnimated.h"
#import "TABAnimationMethod.h"
#import "TABManagerMethod.h"

#import "UIView+TABControlAnimation.h"

#import "TABAnimatedObject.h"
#import "UIView+Animated.h"
#import "TABLayer.h"

#import <objc/runtime.h>

@implementation UICollectionViewCell (TABLayoutSubviews)

+ (void)load {

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // Gets the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Get the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_collection_layoutSubviews));
        
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_collection_layoutSubviews {
    [self tab_collection_layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 如果父视图开启动画，同时满足闪光灯条件，则为cell添加闪光灯动画
        UICollectionView *superView = (UICollectionView *)self.superview;
        
        switch (superView.tabAnimated.animatedStyle) {
                
            case TABViewAnimationStart:
                
                // start animations
                [TABManagerMethod getNeedAnimationSubViews:self
                                             withSuperView:superView
                                              withRootView:self];
                
                [self.tabLayer udpateSublayers];
                
                // shimmer animation
                if ([TABManagerMethod canAddShimmer:self]) {
                    [TABAnimationMethod addShimmerAnimationToView:self
                                                         duration:[TABViewAnimated sharedAnimated].animatedDurationShimmer];
                    break;
                }
                
                // bin animation
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
    });
}

@end
