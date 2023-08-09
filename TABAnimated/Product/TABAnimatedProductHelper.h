//
//  TABAnimatedProductHelper.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TABAnimatedProduction, TABComponentLayer, TABViewAnimated;

#define TABAnimatedProductHelperScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TABAnimatedProductHelper : NSObject

/// 填充数据, 并启动嵌套的view
+ (void)fullDataAndStartNestAnimation:(UIView *)view isHidden:(BOOL)isHidden superView:(UIView *)superView rootView:(UIView *)rootView;

/**
 恢复数据
 
 @param view 上层view
 */
+ (void)resetData:(UIView *)view;

/**
是否可用于生产骨架

@param view 目标view
*/
+ (BOOL)canProduct:(UIView *)view tabAnimated:(TABViewAnimated *)tabAnimated;

+ (TABComponentLayer *)getBackgroundLayerWithView:(UIView *)view controlView:(UIView *)controlView;

/**
将产品绑定到view上

@param view 目标view
@param production 目标production
@param animatedHeight 上层设置的高度
*/
+ (void)bindView:(UIView *)view production:(TABAnimatedProduction *)production animatedHeight:(CGFloat)animatedHeight;

/**
为Layer添加红色tag角标

@param layer 目标layer
@param isLines 是否为多行layer
*/
+ (void)addTagWithComponentLayer:(TABComponentLayer *)layer isLines:(BOOL)isLines needFrame:(BOOL)needFrame superLayer:(TABComponentLayer *)superLayer;

/**
获取指定情景下production的key

@param controllerName 控制器名称
@param targetClass 目标class
@param frame 控制视图的frame
*/
+ (nullable NSString *)getKeyWithControllerName:(NSString *)controllerName targetClass:(Class)targetClass frame:(CGRect)frame;

+ (void)penerateIndexArray:(NSArray <NSNumber *> *)penerateIndexArray production:(TABAnimatedProduction *)production;
    
@end

NS_ASSUME_NONNULL_END
