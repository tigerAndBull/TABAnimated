//
//  TABDropAnimation.h
//  AnimatedDemo
//
//  Created by tigerAndBull on 2020/3/12.
//  Copyright © 2020 tigerAndBull. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 下坠动画全局属性
 */
@interface TABDropAnimation : NSObject

/**
 * 豆瓣动画帧时长，默认值为0.4，你可以理解为`变色速度`。
 */
@property (nonatomic, assign) CGFloat dropAnimationDuration;

/**
 * 豆瓣动画变色值，默认值为0xE1E1E1
 */
@property (nonatomic, strong) UIColor *dropAnimationDeepColor;

/**
 * 暗黑模式下豆瓣动画变色值
 */
@property (nonatomic, strong) UIColor *dropAnimationDeepColorInDarkMode;

@end

NS_ASSUME_NONNULL_END
