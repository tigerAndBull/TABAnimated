//
//  TABManagerMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABManagerMethod : NSObject

+ (void)getNeedAnimationSubViews:(UIView *)view
                   withSuperView:(UIView *)superView
                    withRootView:(UIView *)rootView;

+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view;

+ (BOOL)canAddShimmer:(UIView *)view;

+ (BOOL)canAddBinAnimation:(UIView *)view;

+ (void)endAnimationToSubViews:(UIView *)view;

+ (void)removeAllTABLayersFromView:(UIView *)view;

+ (void)removeMask:(UIView *)view;

+ (void)removeSubLayers:(NSArray *)subLayers;

@end

NS_ASSUME_NONNULL_END
