//
//  UICollectionViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionViewCell+TABLayoutSubviews.h"
#import "TABAnimated.h"

#import <objc/runtime.h>

@implementation UICollectionViewCell (TABLayoutSubviews)

+ (void)load {

    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        // Getting the viewDidLoad method to the class,whose type is a pointer to a objc_method structure.
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        // Getting the method you created.
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_collection_layoutSubviews));
        // Exchange
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_collection_layoutSubviews {
    [self tab_collection_layoutSubviews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // 如果父视图开启动画，同时满足闪光灯条件，则为cell添加闪光灯动画
        UICollectionView *superView = (UICollectionView *)self.superview;
        
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
                
                // shimmer animation
                if ([TABManagerMethod canAddShimmer:self]) {
                    [TABAnimationMethod addShimmerAnimationToView:self
                                                         duration:[TABAnimated sharedAnimated].animatedDurationShimmer key:kTABShimmerAnimation];
                    break;
                }
                
                // bin animation
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
                
                break;
                
            default:
                break;
        }
    });
}

@end
