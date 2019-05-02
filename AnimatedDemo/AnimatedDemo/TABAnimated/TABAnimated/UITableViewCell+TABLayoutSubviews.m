//
//  UITableViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/9/21.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UITableViewCell+TABLayoutSubviews.h"
#import "TABAnimated.h"

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
        
        switch (superView.tabAnimated.state) {
            
            case TABViewAnimationStart: {
                
                if (nil == self.tabLayer) {
                    self.tabLayer = TABLayer.new;
                    self.tabLayer.frame = self.bounds;
                    self.tabLayer.animatedHeight = superView.tabAnimated.animatedHeight;
                    self.tabLayer.animatedCornerRadius = superView.tabAnimated.animatedCornerRadius;
                    self.tabLayer.cancelGlobalCornerRadius = superView.tabAnimated.cancelGlobalCornerRadius;
                    [self.layer addSublayer:self.tabLayer];
                }
                
                NSMutableArray <TABComponentLayer *> *array = @[].mutableCopy;
                // start animations
                [TABManagerMethod getNeedAnimationSubViews:self
                                             withSuperView:superView
                                              withRootView:self
                                                     array:array];
                
                self.tabLayer.componentLayerArray = array;
                
                __weak typeof(self) weakSelf = self;
                if (superView.tabAnimated.categoryBlock) {
                    superView.tabAnimated.categoryBlock(weakSelf);
                }
                
                self.tabLayer.animatedBackgroundColor = superView.tabAnimated.animatedBackgroundColor;
                self.tabLayer.animatedColor = superView.tabAnimated.animatedColor;
                [self.tabLayer updateSublayers:self.tabLayer.componentLayerArray.mutableCopy];
                
                // add shimmer animation
                if ([TABManagerMethod canAddShimmer:self]) {
                    [TABAnimationMethod addShimmerAnimationToView:self
                                                         duration:[TABAnimated sharedAnimated].animatedDurationShimmer key:kTABShimmerAnimation];
                    break;
                }
                
                if ([TABManagerMethod canAddBinAnimation:self]) {
                    [TABAnimationMethod addAlphaAnimation:self
                                                 duration:[TABAnimated sharedAnimated].animatedDurationBin
                                                      key:kTABAlphaAnimation];
                }
            }
                
                break;
                
            case TABViewAnimationEnd: {
                // end animations
                [TABManagerMethod endAnimationToSubViews:self];
                [TABManagerMethod removeMask:self];
            }
                
            default:
                break;
        }
    });
}

@end
