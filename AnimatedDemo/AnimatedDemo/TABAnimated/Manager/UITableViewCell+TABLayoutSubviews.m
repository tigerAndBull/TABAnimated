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
                
                NSMutableArray <TABComponentLayer *> *array = @[].mutableCopy;
                // start animations
                [TABManagerMethod getNeedAnimationSubViews:self
                                             withSuperView:superView
                                              withRootView:self
                                         withRootSuperView:superView
                                                     array:array];
                
                self.tabLayer.componentLayerArray = array;
                
                __weak typeof(self) weakSelf = self;
                if (superView.tabAnimated.categoryBlock) {
                    superView.tabAnimated.categoryBlock(weakSelf);
                }
                
                if (!superView.tabAnimated.isNest) {
                    self.tabLayer.animatedBackgroundColor = superView.tabAnimated.animatedBackgroundColor;
                    self.tabLayer.animatedColor = superView.tabAnimated.animatedColor;
                    [self.tabLayer updateSublayers:self.tabLayer.componentLayerArray.mutableCopy];
                    
                    // add shimmer animation
                    if ([TABManagerMethod canAddShimmer:superView]) {
                        [TABAnimationMethod addShimmerAnimationToView:self
                                                             duration:[TABAnimated sharedAnimated].animatedDurationShimmer
                                                                  key:kTABShimmerAnimation];
                        break;
                    }

                    // add bin animation
                    if ([TABManagerMethod canAddBinAnimation:superView]) {
                        [TABAnimationMethod addAlphaAnimation:self
                                                     duration:[TABAnimated sharedAnimated].animatedDurationBin
                                                          key:kTABAlphaAnimation];
                        break;
                    }
                    
                    // add drop animation
                    if ([TABManagerMethod canAddDropAnimation:superView]) {
                        
                        UIColor *deepColor;
                        if (superView.tabAnimated.dropAnimationDeepColor) {
                            deepColor = superView.tabAnimated.dropAnimationDeepColor;
                        }else {
                            deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColor;
                        }
                        
                        CGFloat duration = 0;
                        if (superView.tabAnimated.dropAnimationDuration != 0.) {
                            duration = superView.tabAnimated.dropAnimationDuration;
                        }else {
                            duration = [TABAnimated sharedAnimated].dropAnimationDuration;
                        }
                        
                        for (NSInteger i = 0; i < self.tabLayer.resultLayerArray.count; i++) {
                            TABComponentLayer *layer = self.tabLayer.resultLayerArray[i];
                            if (layer.removeOnDropAnimation) {
                                continue;
                            }
                            [TABAnimationMethod addDropAnimation:layer
                                                           index:layer.dropAnimationIndex
                                                        duration:duration*(self.tabLayer.dropAnimationCount+1)
                                                           count:self.tabLayer.dropAnimationCount+1
                                                        stayTime:layer.dropAnimationStayTime
                                                       deepColor:deepColor
                                                             key:kTABDropAnimation];
                        }
                    }
                    
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
