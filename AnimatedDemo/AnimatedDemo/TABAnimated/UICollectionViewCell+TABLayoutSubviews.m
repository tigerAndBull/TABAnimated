//
//  UICollectionViewCell+Animated.m
//  AnimatedDemo
//
//  Created by tigerAndBull on 2018/10/12.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import "UICollectionViewCell+TABLayoutSubviews.h"
#import <objc/runtime.h>

@implementation UICollectionViewCell (TABLayoutSubviews)

+ (void)load {

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
        Method newMethod = class_getInstanceMethod([self class], @selector(tab_collection_layoutSubviews));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

#pragma mark - Exchange Method

- (void)tab_collection_layoutSubviews {
    [self tab_collection_layoutSubviews];

    dispatch_async(dispatch_get_main_queue(), ^{

        UICollectionView *superView = (UICollectionView *)self.superview;

        if (![superView isKindOfClass:[UICollectionView class]]) {
            return;
        }

        NSIndexPath *indexPath = [superView indexPathForCell:self];
        TABCollectionAnimated *tabAnimated = (TABCollectionAnimated *)((UICollectionView *)superView.tabAnimated);

        if (tabAnimated.state == TABViewAnimationStart &&
            [tabAnimated currentSectionIsAnimating:superView
                                           section:indexPath.section] &&
            !self.tabComponentManager.isLoad) {

            NSMutableArray <TABComponentLayer *> *array = @[].mutableCopy;
            // start animations
            [TABManagerMethod getNeedAnimationSubViews:self
                                         withSuperView:superView
                                          withRootView:self
                                     withRootSuperView:superView
                                          isInNestView:NO
                                                 array:array];

            [self.tabComponentManager installBaseComponent:array.copy];
            
            if (self.tabComponentManager.baseComponentArray.count != 0) {
                __weak typeof(self) weakSelf = self;
                
                if (superView.tabAnimated.categoryBlock) {
                    superView.tabAnimated.categoryBlock(weakSelf);
                }
                
                if (superView.tabAnimated.adjustBlock) {
                    superView.tabAnimated.adjustBlock(weakSelf.tabComponentManager);
                }
                
                if (superView.tabAnimated.adjustWithSectionBlock) {
                    superView.tabAnimated.adjustWithSectionBlock(weakSelf.tabComponentManager, indexPath.section);
                }
            }
            
            [self.tabComponentManager updateComponentLayers];

            if (self.tabComponentManager.nestView) {
                [TABManagerMethod resetData:self];
            }

            // add shimmer animation
            if ([TABManagerMethod canAddShimmer:superView]) {
                
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
            }
            
            [TABManagerMethod resetData:self];
            self.tabComponentManager.isLoad = YES;

            if (!superView.tabAnimated.isNest) {

                // add bin animation
                if ([TABManagerMethod canAddBinAnimation:superView]) {
                    [TABAnimationMethod addAlphaAnimation:self
                                                 duration:[TABAnimated sharedAnimated].animatedDurationBin
                                                      key:kTABAlphaAnimation];
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
                    CGFloat cutTime = 0.02;
                    CGFloat allCutTime = cutTime*(self.tabComponentManager.resultLayerArray.count-1)*(self.tabComponentManager.resultLayerArray.count)/2.0;
                    if (superView.tabAnimated.dropAnimationDuration != 0.) {
                        duration = superView.tabAnimated.dropAnimationDuration;
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

            }

            if (self.tabComponentManager.nestView) {
                [self.tabComponentManager.nestView tab_startAnimation];
            }
        }

        // 结束动画
        if (tabAnimated.state == TABViewAnimationEnd) {
            [TABManagerMethod endAnimationToSubViews:self];
            [TABManagerMethod removeMask:self];
        }
    });
}

@end
