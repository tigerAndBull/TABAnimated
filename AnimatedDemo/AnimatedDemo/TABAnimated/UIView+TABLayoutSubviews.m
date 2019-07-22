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
            [self isKindOfClass:[UICollectionView class]] ||
            [self isKindOfClass:[UICollectionViewCell class]] ||
            [self isKindOfClass:[UITableViewCell class]]) {
            return;
        }
        
        if (nil != self.tabAnimated) {
            
            switch (self.tabAnimated.state) {
                    
                case TABViewAnimationStart: {
                    
                    // change status
                    self.tabAnimated.state = TABViewAnimationRunning;
                    
                    // start animations
                    NSMutableArray <TABComponentLayer *> *array = @[].mutableCopy;
                    [TABManagerMethod getNeedAnimationSubViews:self
                                                 withSuperView:self
                                                  withRootView:self
                                             withRootSuperView:self
                                                  isInNestView:NO
                                                         array:array];
                    
                    [self.tabComponentManager installBaseComponent:array.copy];
                    
                    if (self.tabComponentManager.baseComponentArray.count != 0) {
                        
                        __weak typeof(self) weakSelf = self;
                        
                        if (self.tabAnimated.categoryBlock) {
                            self.tabAnimated.categoryBlock(weakSelf);
                        }
                        
                        if (self.tabAnimated.adjustBlock) {
                            self.tabAnimated.adjustBlock(weakSelf.tabComponentManager);
                        }
                    }
                    
                    self.tabComponentManager.animatedBackgroundColor = self.tabAnimated.animatedBackgroundColor;
                    self.tabComponentManager.animatedColor = self.tabAnimated.animatedColor;
                    [self.tabComponentManager updateComponentLayers];
                    
                    if (self.tabComponentManager.nestView) {
                        [TABManagerMethod resetData:self];
                    }
                    
                    // add shimmer animation
                    if ([TABManagerMethod canAddShimmer:self]) {
                        for (NSInteger i = 0; i < self.tabComponentManager.resultLayerArray.count; i++) {
                            TABComponentLayer *layer = self.tabComponentManager.resultLayerArray[i];
                            UIColor *baseColor = [TABAnimated sharedAnimated].shimmerBackColor;
                            CGFloat brigtness = [TABAnimated sharedAnimated].shimmerBrightness;
                            layer.colors = @[
                                             (id)baseColor.CGColor,
                                             (id)[TABAnimationMethod brightenedColor:baseColor brightness:brigtness].CGColor,
                                             (id)baseColor.CGColor
                                             ];
                            [TABAnimationMethod addShimmerAnimationToLayer:layer
                                                                  duration:[TABAnimated sharedAnimated].animatedDurationShimmer
                                                                       key:kTABShimmerAnimation
                                                                 direction:[TABAnimated sharedAnimated].shimmerDirection];
                            
                        }
                        break;
                    }
                    
                    // add bin animation
                    if ([TABManagerMethod canAddBinAnimation:self]) {
                        [TABAnimationMethod addAlphaAnimation:self
                                                     duration:[TABAnimated sharedAnimated].animatedDurationBin key:kTABAlphaAnimation];
                        break;
                    }
                    
                    // add drop animation
                    if ([TABManagerMethod canAddDropAnimation:self]) {
                        
                        UIColor *deepColor;
                        if (self.tabAnimated.dropAnimationDeepColor) {
                            deepColor = self.tabAnimated.dropAnimationDeepColor;
                        }else {
                            deepColor = [TABAnimated sharedAnimated].dropAnimationDeepColor;
                        }
                        
                        CGFloat duration = 0;
                        CGFloat cutTime = 0.02;
                        CGFloat allCutTime = cutTime*(self.tabComponentManager.resultLayerArray.count-1)*(self.tabComponentManager.resultLayerArray.count)/2.0;
                        if (self.tabAnimated.dropAnimationDuration != 0.) {
                            duration = self.tabAnimated.dropAnimationDuration;
                        }else {
                            duration = [TABAnimated sharedAnimated].dropAnimationDuration;
                        }
                        
                        for (NSInteger i = 0; i < self.tabComponentManager.resultLayerArray.count; i++) {
                            TABComponentLayer *layer = self.tabComponentManager.resultLayerArray[i];
                            if (layer.removeOnDropAnimation) {
                                continue;
                            }
                            [TABAnimationMethod addDropAnimation:layer
                                                           index:layer.dropAnimationIndex
                                                        duration:duration*(self.tabComponentManager.dropAnimationCount+1)-allCutTime
                                                           count:self.tabComponentManager.dropAnimationCount+1
                                                        stayTime:layer.dropAnimationStayTime-i*cutTime
                                                       deepColor:deepColor
                                                             key:kTABDropAnimation];
                        }
                    }
                    
                    if (self.tabComponentManager.nestView) {
                        [self.tabComponentManager.nestView tab_startAnimation];
                    }
                }
                    
                    break;
                    
                default:
                    break;
            }
        }
    });
}

@end
