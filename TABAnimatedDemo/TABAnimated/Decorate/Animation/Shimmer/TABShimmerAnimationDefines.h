//
//  TABShimmerAnimationDefines.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/4/21.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#ifndef TABShimmerAnimationDefines_h
#define TABShimmerAnimationDefines_h

/**
 闪光灯动画全局属性
 */

// 闪光灯方向
typedef NS_ENUM(NSUInteger, TABShimmerDirection) {
    // 从左往右
    TABShimmerDirectionToRight = 0,
    // 从右往左
    TABShimmerDirectionToLeft,
};

// 闪光灯起始位置
typedef NS_ENUM(NSUInteger, TABShimmerProperty) {
    // 起
    TABShimmerPropertyStartPoint = 0,
    // 始
    TABShimmerPropertyEndPoint,
};

typedef struct {
    CGPoint startValue;
    CGPoint endValue;
} TABShimmerTransition;

#endif /* TABShimmerAnimationDefines_h */
