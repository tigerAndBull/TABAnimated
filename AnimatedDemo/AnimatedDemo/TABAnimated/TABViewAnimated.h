//
//  TABViewAnimated.h
//  lifeAndSport
//
//  Created by tigerAndBull on 2018/9/14.
//  Copyright © 2018年 tigerAndBull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIView+Animated.h"

@interface TABViewAnimated : NSObject

+ (void)startOrEndAnimated:(UITableViewCell *)cell;

/**
 加载CALayer,设置动画,同时启动

 @param view 需要动画的view
 @param color 动画颜色
 */
+ (void)initLayerWithView:(UIView *)view withColor:(UIColor *)color;

/**
 根据动画类型设置对应基础动画

 @param style 动画类型
 @return 动画
 */
+ (CABasicAnimation *)scaleXAnimation:(TABViewLoadAnimationStyle)style;

@end
