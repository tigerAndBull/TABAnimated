//
//  TABManagerMethod.h
//  AnimatedDemo
//
//  github: https://github.com/tigerAndBull/TABAnimated
//  jianshu: https://www.jianshu.com/p/6a0ca4995dff
//
//  集成问答文档：https://www.jianshu.com/p/34417897915a
//  历史更新文档：https://www.jianshu.com/p/e3e9ea295e8a
//  动画下标说明：https://www.jianshu.com/p/8c361ba5aa18
//  豆瓣效果说明：https://www.jianshu.com/p/1a92158ce83a
//  嵌套视图说明：https://www.jianshu.com/p/cf8e37195c11
//
//  Created by tigerAndBull on 2019/2/21.
//  Copyright © 2019年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 集成时，开发者不需要关心。
 该文件用于管理动画上层依赖的view。
 */

@class TABComponentManager, TABComponentLayer;

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
 映射出所view中的TABComponentLayer，组装起来，并加入约定好的动画

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
                    isInNestView:(BOOL)isInNestView
                           array:(NSMutableArray <TABComponentLayer *> *)array;

/**
 排除部分不符合条件的view
 
 @param view 目标view
 @return 判断结果
 */
+ (BOOL)judgeViewIsNeedAddAnimation:(UIView *)view;

/**
 是否可以添加闪光灯动画
 
 @param view 目标view
 @return 判断结果
 */
+ (BOOL)canAddShimmer:(UIView *)view;

/**
 是否可以添加呼吸灯动画
 
 @param view 目标view
 @return 判断结果
 */
+ (BOOL)canAddBinAnimation:(UIView *)view;

/**
 是否可以添加跳跃动画
 
 @param view 目标view
 @return 判断结果
 */
+ (BOOL)canAddDropAnimation:(UIView *)view;

/**
 结束被嵌套视图的动画
 
 @param view 目标view
 */
+ (void)endAnimationToSubViews:(UIView *)view;

+ (void)removeAllTABLayersFromView:(UIView *)view;

+ (void)removeMask:(UIView *)view;

+ (void)removeSubLayers:(NSArray *)subLayers;

+ (void)addExtraAnimationWithSuperView:(UIView *)superView
                            targetView:(UIView *)targetView
                               manager:(TABComponentManager *)manager;

+ (void)runAnimationWithSuperView:(UIView *)superView
                       targetView:(UIView *)targetView
                         section:(NSInteger)section
                           isCell:(BOOL)isCell
                          manager:(TABComponentManager *)manager;

@end

NS_ASSUME_NONNULL_END
