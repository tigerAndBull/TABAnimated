//
//  TABManagerMethod.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TABComponentLayer.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Methods in the file are used to manager the animation.
 **/
@interface TABManagerMethod : NSObject

/**
 填充数据

 @param view 上层view
 */
+ (void)fullData:(UIView *)view;

/**
 恢复数据

 @param view 上层view
 */
+ (void)resetData:(UIView *)view;


/**
 映射出所view中的TABComponentLayer

 @param view 需要映射的view
 @param superView view的父视图
 @param rootView 根view
 @param rootSuperView 根view的父视图
 @param array 得到的TABComponentLayer集合
 */
+ (void)getNeedAnimationSubViews:(UIView *)view
                   withSuperView:(UIView *)superView
                    withRootView:(UIView *)rootView
               withRootSuperView:(UIView *)rootSuperView
                           array:(NSMutableArray <TABComponentLayer *> *)array;

/**
 排除部分不符合条件的view

 @param view 目标view
 @return 结果
 */
+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view;

/**
 是否可以添加闪光灯动画

 @param view 目标view
 @return 结果
 */
+ (BOOL)canAddShimmer:(UIView *)view;

/**
 是否可以添加呼吸灯动画

 @param view 目标view
 @return 结果
 */
+ (BOOL)canAddBinAnimation:(UIView *)view;

/**
 是否可以添加跳跃动画

 @param view 目标view
 @return 结果
 */
+ (BOOL)canAddDropAnimation:(UIView *)view;

/**
 结束动画后移除相关TABCompentLayer

 @param view 目标view
 */
+ (void)endAnimationToSubViews:(UIView *)view;

+ (void)removeAllTABLayersFromView:(UIView *)view;

+ (void)removeMask:(UIView *)view;

+ (void)removeSubLayers:(NSArray *)subLayers;

@end

NS_ASSUME_NONNULL_END
