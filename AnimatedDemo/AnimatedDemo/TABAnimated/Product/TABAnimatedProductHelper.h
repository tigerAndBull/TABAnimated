//
//  TABAnimatedProductHelper.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/5.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABAnimatedProductHelper : NSObject

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

+ (void)hiddenSubViews:(UIView *)view;

/**
是否可用于生产骨架

@param view 目标view
*/
+ (BOOL)canProduct:(UIView *)view;

+ (TABComponentLayer *)getBackgroundLayerWithView:(UIView *)view controlView:(UIView *)controlView;

+ (void)bindView:(UIView *)view production:(TABAnimatedProduction *)production;

+ (void)addTagWithComponentLayer:(TABComponentLayer *)layer isLines:(BOOL)isLines;

+ (TABComponentLayer *)getShadowLayer:(UIView *)view;

+ (NSString *)getClassNameWithTargetClass:(Class)targetClass;
+ (NSString *)getKeyWithControllerName:(NSString *)controllerName targetClass:(Class)targetClass;
    
@end

NS_ASSUME_NONNULL_END
