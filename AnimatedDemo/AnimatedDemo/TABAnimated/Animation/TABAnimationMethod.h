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
 TABAnimated在管理
 这个文件存放的是`热插拔`的动画，集成不需要关心的文件
 */

typedef enum : NSUInteger {
    TABShimmerDirectionToRight = 0,    // 从左往右
    TABShimmerDirectionToLeft,         // 从右往左
} TABShimmerDirection;                 // 闪光灯方向

typedef enum : NSUInteger {
    TABShimmerPropertyStartPoint = 0,
    TABShimmerPropertyEndPoint,
} TABShimmerProperty;

typedef struct {
    CGPoint startValue;
    CGPoint endValue;
} TABShimmerTransition;

@interface TABAnimationMethod : NSObject

/**
 伸缩动画
 
 @param duration 伸缩（一来一回）时长
 @param toValue 伸缩的比例
 @return 动画对象
 */
+ (CABasicAnimation *)scaleXAnimationDuration:(CGFloat)duration
                                      toValue:(CGFloat)toValue;

/**
 CALayer加入闪光灯动画

 @param layer 目标layer
 @param duration 一次闪烁时长
 @param key 指定key
 @param direction 闪烁方向
 */
+ (void)addShimmerAnimationToLayer:(CALayer *)layer
                          duration:(CGFloat)duration
                               key:(NSString *)key
                         direction:(TABShimmerDirection)direction;

/**
 UIView加入呼吸灯动画

 @param view 目标view
 @param duration 单次呼吸时长
 @param key 指定key
 */
+ (void)addAlphaAnimation:(UIView *)view
                 duration:(CGFloat)duration
                      key:(NSString *)key;

/**
 CALayer加入豆瓣下坠效果，该方法需要配合计算使用。

 @param layer 目标layer
 @param index 所处集合下标
 @param duration 时长
 @param count 下坠总数
 @param stayTime 停留时间
 @param deepColor 变色值
 @param key 指定key
 */
+ (void)addDropAnimation:(CALayer *)layer
                   index:(NSInteger)index
                duration:(CGFloat)duration
                   count:(NSInteger)count
                stayTime:(CGFloat)stayTime
               deepColor:(UIColor *)deepColor
                     key:(NSString *)key;

/**
 UIView加入呼吸灯动画

 @param view 目标view
 */
+ (void)addEaseOutAnimation:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
