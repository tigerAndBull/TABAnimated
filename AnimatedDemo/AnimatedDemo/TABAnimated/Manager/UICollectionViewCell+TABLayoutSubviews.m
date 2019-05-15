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
        
        UICollectionView *superView = (UICollectionView *)self.superview;
        
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
                
                break;
                
            default:
                break;
        }
    });
}

@end
