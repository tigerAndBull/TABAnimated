//
//  TABAnimationMethod.h
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
//  Created by tigerAndBull on 2018/12/28.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 这个文件存放的是`热插拔`的动画，集成不需要关心的文件
 * Methods in the file are about to animation type.
 **/

typedef enum : NSUInteger {
    TABShimmerDirectionToRight = 0,  // 从左往右
    TABShimmerDirectionToLeft,       // 从右往左
} TABShimmerDirection;               // 闪光灯方向

typedef enum : NSUInteger {
    TABShimmerPropertyStartPoint = 0,
    TABShimmerPropertyEndPoint,
} TABShimmerProperty;

typedef struct {
    CGPoint startValue;
    CGPoint endValue;
} TABShimmerTransition;

@interface TABAnimationMethod : NSObject

+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue;

+ (void)addShimmerAnimationToLayer:(CALayer *)layer
                          duration:(CGFloat)duration
                               key:(NSString *)key
                         direction:(TABShimmerDirection)direction;

+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key;

+ (void)addDropAnimation:(CALayer *)layer
                   index:(NSInteger)index
                duration:(CGFloat)duration
                   count:(NSInteger)count
                stayTime:(CGFloat)stayTime
               deepColor:(UIColor *)deepColor
                     key:(NSString *)key;

+ (void)addEaseOutAnimation:(UIView *)view;

+ (UIColor *)brightenedColor:(UIColor *)color
                  brightness:(CGFloat)brightness;

@end

NS_ASSUME_NONNULL_END
